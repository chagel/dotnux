# Fresh Omarchy setup

`make` links files. It does not enable services, grant credentials or install
plugins. Ordered by dependency. See [omarchy.md](omarchy.md) for why.

## 1. Check the graphical session

Omarchy 4 handles login itself — SDDM autologins into
`/usr/local/share/wayland-sessions/omarchy.desktop`, which starts the compositor
through uwsm. Nothing to choose.

```sh
systemctl --user is-active graphical-session.target   # expect: active
```

Worth checking because fcitx5, bt-agent, crash-watch, sleep-lock and voxtype are
all `WantedBy` it, and Omarchy's input-method variables only reach apps through
the systemd user manager. Inactive looks like several unrelated bugs at once.

If inactive, start them for this session and look at whether uwsm generated units
in `$XDG_RUNTIME_DIR/systemd/user/`:

```sh
systemctl --user start omarchy-fcitx5.service bt-agent.service \
  omarchy-crash-watch.service omarchy-sleep-lock.service voxtype.service
```

Ignore `start-hyprland` while debugging: it is SDDM's greeter command and also
what `hyprland.desktop` execs under uwsm. Neither means uwsm was bypassed.

## 2. Clone and link

```sh
git clone --recurse-submodules https://github.com/chagel/Dotnux ~/Work/Dotnux
ln -s ~/Work/Dotnux ~/Dotfiles      # configs and scripts use this path
cd ~/Dotfiles && make
```

## 3. 1Password — before mail or calendar

Credentials come from 1Password via `scripts/mail-pass`, cached in the kernel
keyring for 12h.

```sh
omarchy pkg add 1password 1password-cli
```

Then **Settings → Developer → Integrate with 1Password CLI** in the app. GUI
only: `settings.json` is HMAC-signed. Do *not* add yourself to the `onepassword`
group — the package's install script says not to.

```sh
op whoami && op read 'op://Private/Google Calendar API/client id' >/dev/null
```

Both must pass first; `op read` hangs rather than fails when the integration is
off.

## 4. Terminal

```sh
omarchy default terminal ghostty
printf '\nconfig-file = ?"local.conf"\n' >> ~/.config/ghostty/config
ghostty +validate-config
```

That line is added by hand because `omarchy-font-set` and
`omarchy-display-text-size` `sed -i` that file and would replace a link.

## 5. Timers

Linked by `make`, but enabling is manual:

```sh
systemctl --user daemon-reload
systemctl --user enable --now mbsync.timer notmuch.timer vdirsyncer.timer
```

## 6. Mail

Run once interactively so the keyring is warm:

```sh
mbsync -Va && notmuch new
```

## 7. Calendar

One-time browser consent per Google account. Accounts not owning the Cloud
project must be test users on the consent screen.

```sh
vdirsyncer discover      # yes to create missing local collections
vdirsyncer sync && vdirsyncer metasync
khal list today 7d

omarchy plugin add https://github.com/tmn73/omarchy-calendar.git --enable --yes
make shell-restore
```

`scripts/calendar-events` writes the widget's JSON from khal on every sync.

## 8. Verify

```sh
make audit
hyprctl configerrors
systemctl --user list-timers
```

## Not tracked

- `~/.config/hypr/monitors.lua` — keyed to monitor serials; use `hyprmoncfg`
- `~/.config/xdg-terminals.list` — written by `omarchy default terminal`
- `~/.config/ghostty/config`, `~/.config/omarchy/shell.json` — Omarchy rewrites
  both; only our `local.conf` and the `shell.json` snapshot are tracked
- OAuth tokens, keyring entries, `~/.mail`

Restore hazard: `vdirsyncer`'s `*.collections` cache stores absolute paths.
Restored from a backup made under another username it points at a home that does
not exist, and every sync silently does nothing. Delete the cache files and
re-run `vdirsyncer discover`.
