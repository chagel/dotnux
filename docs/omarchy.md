# Customizing Omarchy

Omarchy ships opinionated config and keeps maintaining it. The way to stay stable
across its releases is to customize as little as possible, and to keep what is
left out of the files it manages.

## Two rules

**1. If Omarchy has no opinion about the file, symlink it from this repo.**

Normal dotfiles. `links.conf` covers the directories where something else also
writes, so only our files get linked and the directory stays real; everything
else under `configs/` is linked whole by `base.mk`.

**2. If Omarchy owns the file, put our settings in a separate file it includes.**

Its config stays local and unlinked; ours sits beside it and is named from
theirs. Ghostty is the worked example — `configs/ghostty/overrides/local.conf`
is linked into `~/.config/ghostty/`, and Omarchy's own `config` gains one line:

```
config-file = ?"local.conf"
```

Colours and font size stay Omarchy's. If the app has no include mechanism, the
honest options are to stop customizing it or to keep a snapshot. `shell.json` is
the one snapshot here, and because it ships with the system and is only ever
overwritten in place, it is never missing — so neither direction is automatic:

```
make shell-capture   live -> repo, once the bar is how you want it
make shell-restore   repo -> live, after `omarchy refresh shell` resets it
```

Omarchy also has override directories of its own, which are the best place to be
when they fit:

```
~/.config/omarchy/themed/<name>.tpl        theme-rendered config; ours beats stock,
                                           a new name adds an app to theming
~/.config/omarchy/hooks/<event>.d/         theme-set, font-set, post-boot,
                                           post-update, battery-low, pre-refresh-pacman
```

`configs/omarchy/themed/fcitx5.conf.tpl` uses the first (Omarchy does not theme
fcitx5 at all) and the hooks reload it afterwards.

## One prohibition

**Never symlink a file Omarchy rewrites in place.** `sed -i` renames its temp
file over the target and `omarchy-shell-config` `mv`s over a literal path.
Neither follows a link, so the link becomes a regular file and the config leaves
git without a word — the only failure here that is completely silent.

`make audit` checks it, and runs from `post-update.d` after every
`omarchy update`. It derives the list from the installed scripts instead of
trusting a fixed one, so a new file shows up on its own.

## Keep the surface small

Most complexity came from carrying config for things Omarchy already does, or for
apps that were not installed. A custom theme engine, a bar, a launcher and two
uninstalled terminals were about a third of this repo. Before adding config, ask
whether Omarchy already covers it — and delete rather than maintain when it
starts to.

Two couplings worth an eye after a big Omarchy release, neither worth machinery:
`configs/hypr/overrides/hyprland.lua` is Omarchy's file plus one flag, and each
`hl.unbind(...)` in `bindings.lua` assumes upstream still binds that key.
