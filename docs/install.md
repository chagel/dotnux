# Setting up a fresh Omarchy with this repo

`make` links files. It does not enable services, grant credentials, or install
plugins, so the steps below are ordered by what depends on what. See
[omarchy.md](omarchy.md) for *why* customization is arranged the way it is.

## 1. Log in through the uwsm session — do this first

At the login screen pick **"Hyprland (uwsm-managed)"**, not plain "Hyprland".

Plain Hyprland runs `start-hyprland` directly, so `graphical-session.target`
never activates. Everything `WantedBy` it stays dead — fcitx5, bt-agent,
crash-watch, sleep-lock, voxtype — and the input-method variables Omarchy sets
in `environment.d` never reach any app, because only the systemd user manager
reads them. Wrong session here looks like half a dozen unrelated bugs later.

Check it took:

```sh
systemctl --user is-active graphical-session.target   # expect: active
```

## 2. Clone and link

```sh
git clone --recurse-submodules https://github.com/chagel/Dotnux ~/Work/Dotnux
ln -s ~/Work/Dotnux ~/Dotfiles      # scripts and configs refer to this path
cd ~/Dotfiles && make
```

`make` creates the destination directories, links everything per `links.conf`,
and rebuilds the desktop database.

## 3. 1Password CLI — needed before mail or calendar

Mail and calendar credentials come from 1Password through `scripts/mail-pass`,
which caches them in the kernel keyring for 12h.

```sh
omarchy pkg add 1password 1password-cli
```

Then in the desktop app: **Settings → Developer → Integrate with 1Password
CLI**. This has to be done in the GUI — `settings.json` is HMAC-signed and a
hand-written toggle is rejected. Do not add yourself to the `onepassword` group;
the AUR package's own install script says not to, and the setgid helper depends
on it.

```sh
op whoami && op read 'op://Private/Google Calendar API/client id' >/dev/null
```

Both must succeed before step 6 or 7 will work. `op read` hangs rather than
failing when the integration is off.

## 4. Terminal

```sh
omarchy default terminal ghostty
```

Then add our settings to the config Omarchy owns — one line, by hand, because
`omarchy-font-set` and `omarchy-display-text-size` rewrite that file with
`sed -i` and would replace a link:

```sh
printf '\nconfig-file = ?"local.conf"\n' >> ~/.config/ghostty/config
ghostty +validate-config
```

## 5. Sync timers

The units are linked by `make`, but enabling them is not automatic:

```sh
systemctl --user daemon-reload
systemctl --user enable --now mbsync.timer notmuch.timer vdirsyncer.timer
systemctl --user list-timers
```

## 6. Mail

First run interactively so the keyring cache is warm and any 1Password prompt is
answerable:

```sh
mbsync -Va && notmuch new
```

## 7. Calendar

Each Google account needs its own one-time browser consent. Accounts that do not
own the Cloud project must be test users on the consent screen.

```sh
vdirsyncer discover      # answer yes to create missing local collections
vdirsyncer sync && vdirsyncer metasync
khal list today 7d       # sanity check
```

Then the bar widget, which reads a plain JSON file that
`scripts/calendar-events` writes from khal on every sync:

```sh
omarchy plugin add https://github.com/tmn73/omarchy-calendar.git --enable --yes
make shell-restore       # our bar layout, with the clock replaced
```

## 8. Verify

```sh
make audit                    # nothing we link is a file Omarchy rewrites
hyprctl configerrors          # empty
systemctl --user list-timers  # three timers armed
```

## Not tracked — set these by hand

Machine-specific or secret, deliberately outside the repo:

- `~/.config/hypr/monitors.lua` — keyed to monitor serials; generate with
  `hyprmoncfg` or write it per machine
- `~/.config/xdg-terminals.list` — written by `omarchy default terminal`
- `~/.config/ghostty/config`, `~/.config/omarchy/shell.json` — Omarchy rewrites
  both in place; only our `local.conf` and the `shell.json` snapshot are tracked
- OAuth tokens under `~/.local/share/vdirsyncer/`, keyring entries, `~/.mail`

One restore hazard: `vdirsyncer`'s `*.collections` cache stores **absolute**
paths. Restored from a backup made under a different username it points at a
home that does not exist, and every sync warns about missing directories and
does nothing. Delete the cache files and re-run `vdirsyncer discover`.
