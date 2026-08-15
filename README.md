# dotnux — Dotfiles for Linux

My Linux dotfiles. The shared base — Vim, tmux, fish — lives in
[dotbase](https://github.com/chagel/dotbase) as a submodule, so it can be updated
without touching anything specific to this setup. This repo holds the rest: fish,
ghostty, mail, calendar, input method, Hyprland and the scripts around them.

This machine runs [Omarchy](https://omarchy.org/).

- [docs/install.md](docs/install.md) — setting up a fresh machine
- [docs/omarchy.md](docs/omarchy.md) — how customization stays out of the files
  Omarchy manages

## Commands

```sh
make                 # link everything (init + setup)
make audit           # check nothing we link is a file Omarchy rewrites
make shell-capture   # record the live omarchy bar layout into the repo
make shell-restore   # put it back after `omarchy refresh shell`
make update          # update vim, tmux and fish plugins
```

`make` alone is enough on a machine that is already set up; a fresh one needs the
credential, service and plugin steps in [docs/install.md](docs/install.md).

## License

MIT — see [LICENSE](LICENSE).
