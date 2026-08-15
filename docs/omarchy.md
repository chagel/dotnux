# Customizing Omarchy

Omarchy maintains its own config. Customize as little as possible, and keep what
is left out of the files it manages.

## Two rules

**Omarchy has no opinion → symlink it from this repo.** Normal dotfiles.
`links.conf` lists the directories where something else also writes, so only our
files get linked and the directory stays real; the rest of `configs/` is linked
whole by `base.mk`.

**Omarchy owns it → put our settings in a file it includes.** Theirs stays local
and unlinked; ours is linked in beside it. Ghostty is the example —
`configs/ghostty/overrides/local.conf`, pulled in by one line in Omarchy's
`config`:

```
config-file = ?"local.conf"
```

No include mechanism? Stop customizing it, or keep a snapshot. `shell.json` is
the only snapshot; it ships with the system and is overwritten in place, never
missing, so neither direction is automatic:

```sh
make shell-capture   # live -> repo, once the bar is right
make shell-restore   # repo -> live, after `omarchy refresh shell`
```

Omarchy's own override directories are the best place to be when they fit:

```
~/.config/omarchy/themed/<name>.tpl   theme-rendered config; ours beats stock,
                                      a new name adds an app to theming
~/.config/omarchy/hooks/<event>.d/    theme-set, font-set, post-boot,
                                      post-update, battery-low, pre-refresh-pacman
```

`configs/omarchy/themed/fcitx5.conf.tpl` uses the first — Omarchy does not theme
fcitx5 at all — and the hooks reload it.

## One prohibition

**Never symlink a file Omarchy rewrites in place.** `sed -i` and
`omarchy-shell-config`'s `mv` both replace the path rather than writing through
it, so the link becomes a regular file and the config leaves git silently. This
is the only failure here that gives no sign.

`make audit` checks it, and runs from `post-update.d` after every
`omarchy update`. It derives the list from the installed scripts, so a new file
appears on its own.

## Keep the surface small

A theme engine, a bar, a launcher and two uninstalled terminals were a third of
this repo before Omarchy made them redundant. Before adding config, check
whether Omarchy already covers it; delete rather than maintain when it starts to.

Two couplings to eyeball after a big release, neither worth tooling:
`configs/hypr/overrides/hyprland.lua` is Omarchy's file plus one flag, and each
`hl.unbind(...)` in `bindings.lua` assumes upstream still binds that key.
