# Customizing Omarchy without fighting it

Omarchy ships opinionated config and keeps maintaining it. Every release can
recopy a file, rewrite a line inside one, or move something we forked. A dotfiles
repo that just symlinks over the top of that loses quietly: the link gets
replaced by a regular file, or our file stops being read, and nothing says so.

This is the model this repo follows so that does not happen, and so the failures
that remain are *reported* rather than discovered weeks later.

`make audit` checks every invariant here. It also runs from
`configs/omarchy/hooks/post-update.d/dotnux-audit` after each `omarchy update`,
which is the point — the moment upstream can move is the moment to look.

## The only question that matters

**Who writes this file after install?**

Everything follows from the answer:

| Answer | Strategy |
|---|---|
| Nobody — it's ours alone | **1** or **3**: link it from the repo |
| Omarchy provides an override seam for it | **1**: use the seam |
| The app can include a second file | **2**: additive include |
| Omarchy rewrites it in place | **2** or **4** — *never* link it |
| Both we and Omarchy write it, no seam | **4**: snapshot + explicit capture |
| It's machine state, not config | **5**: leave it alone |

Prefer the lowest-numbered strategy that fits. Lower numbers mean Omarchy
expects the customization to be there, so it survives more.

## Strategy 1 — Omarchy's own override directory

Omarchy resolves several things through a user directory that wins over its
stock copy. This is the best case: fully tracked, symlink-safe (the renderer only
ever *reads* our file), and upstream intends it.

```
~/.config/omarchy/themed/<name>.tpl        theme-rendered config; user beats stock,
                                           and a new name ADDS an app to theming
~/.config/omarchy/themes/<slug>/<file>     per-theme literal; beats every template
~/.config/omarchy/hooks/<event>.d/<script> run on theme-set, font-set, post-boot,
                                           post-update, battery-low, pre-refresh-pacman
```

Precedence for anything in `~/.local/state/omarchy/current/theme/`, highest first
— the first writer wins, so a literal file blocks a template entirely:

1. `~/.config/omarchy/themes/<slug>/<name>` — ours, one theme
2. `/usr/share/omarchy/themes/<slug>/<name>` — stock theme
3. `~/.config/omarchy/themed/<name>.tpl` — ours, all themes
4. `/usr/share/omarchy/default/themed/<name>.tpl` — stock template

In this repo: `configs/omarchy/themed/fcitx5.conf.tpl` adds an app Omarchy does
not theme at all; the `theme-set.d` and `font-set.d` hooks reload it afterwards.

Overriding a *stock* template forks it — you inherit none of upstream's later
changes to it. Check 4 of the audit watches for exactly that.

## Strategy 2 — Additive include in a file Omarchy owns

When Omarchy owns a config but the app supports includes, keep our settings in a
separate file we link, and add one line to theirs. Colours and font sizing stay
Omarchy's; only what it has no opinion about is ours.

Every terminal Omarchy ships already includes its theme file this way, which is
also the proof the app supports it:

```
ghostty     config-file = ?"..."
foot        include=...
alacritty   general.import = [ "..." ]
kitty       include ...
```

In this repo: `configs/ghostty/overrides/local.conf` is linked in beside
Omarchy's `config`, which gains one line:

```
config-file = ?"local.conf"
```

Relative paths resolve against the config directory, `?` makes a missing file
non-fatal, and a later include wins. The single exposure is that line: only
`omarchy refresh config ghostty/config` drops it, and audit check 5 catches that.

## Strategy 3 — Runtime layering

Hyprland loads Omarchy's Lua defaults first and our files after, so overriding
needs no fork at all. Link normally.

In this repo: `configs/hypr/overrides/` holds `hyprland.lua` (Omarchy's file plus
`omarchy_default_bindings = false`) and `bindings.lua`, which re-requires the
binding modules it still wants and unbinds individual keys out of them.

Two couplings to keep in mind, both watched by audit check 4: `hyprland.lua` is a
fork, and each `hl.unbind(...)` assumes upstream still binds that key.

## Strategy 4 — Snapshot with explicit capture

Some files have two authors and no seam. `~/.config/omarchy/shell.json` is the
case: our layout lives there, but `omarchy plugin enable` and `omarchy bar move`
rewrite it through `omarchy-shell-config`, and `centerAnchor` is reachable from
no Omarchy command at all — so neither side can be authoritative.

The repo keeps a snapshot, and both directions are explicit:

```
make setup           restores the snapshot ONLY when the live file is missing
make shell-capture   records the live file into the repo
```

Never link one of these. `omarchy-shell-config` renders to a temp file and `mv`s
it over a literal path, which replaces a link with a regular file.

## Strategy 5 — Leave it alone

OAuth tokens, keyring entries, `vdirsyncer` status, caches, `xdg-terminals.list`.
Tracking these either leaks secrets or pins machine-specific state.

Watch for one restore hazard: state files can hold **absolute paths**. A
`vdirsyncer` status restored from a backup still named `/home/mike`, so every
sync warned about a missing directory and did nothing. Deleting the cache and
re-running discovery fixed it. Prefer `$HOME` over a literal path anywhere we
write, and suspect cached paths after any restore.

## The two mechanical traps

Both are silent, both have bitten this repo, and both are checked.

**A file Omarchy rewrites in place must stay a regular file.** `sed -i` renames
its temp file over the target and `mv` replaces the destination path; neither
follows a link, so the link becomes a regular file and the config leaves git.
Currently five files — the four terminal configs (via `omarchy-font-set` and
`omarchy-display-text-size`) and `shell.json` (via `omarchy-shell-config`).
Audit check 1 derives this list from the installed scripts rather than trusting
the number, so a sixth shows up as a warning.

**`ln -sfn` cannot replace a real directory.** `-n` only helps when the
destination is already a link. Against a real directory, `ln` drops the link
*inside* it — leaving `~/.config/foo/foo` and the real config untouched. Any
`configs/<name>` whose destination has to stay a real directory needs a
`links.conf` row instead, so `base.mk` stops whole-directory linking it. Audit
check 3 finds both the hazard and the stray nested links it leaves.

## What `omarchy refresh` will take back

Separate from in-place rewriting, `omarchy refresh` copies stock config over
ours, backing up first. Targets include `hyprland` (every Lua file), `shell`,
`herdr`, `hyprsunset`, `chromium`, `tmux`, `limine`, `plymouth`, `sddm`,
`pacman`, and `refresh config <path>` for anything under
`/usr/share/omarchy/config/`.

So a setting is durable against font and text-size changes if it sits outside the
lines `sed` touches, and durable against `refresh` only if it lives in a file
Omarchy has no stock copy of — which is what strategies 1 and 2 give.

## Practice on an Omarchy release

`omarchy update` runs the audit through the post-update hook and notifies if
anything errored. When it reports:

- **new in-place write target** — decide between strategy 2 and 4 for that file,
  then add it to `KNOWN_REWRITE_TARGETS` in `scripts/omarchy-audit`
- **upstream file changed** — read the diff against our fork, port what matters,
  then `make audit-accept` to re-record the hash
- **lost include line** — a `refresh` ran; put the line back
- **real directory blocking a whole-dir link** — add a `links.conf` row
- **stray nested link** — delete it, then fix the row

Adding customization? Answer the question at the top, pick the lowest strategy
that fits, and if it introduces a new coupling, teach the audit about it —
`WATCHED_UPSTREAM` for a fork, `REQUIRED_INCLUDES` for an include line. An
invariant nobody checks is one we will rediscover the hard way.
