include dotbase/base.mk

# Desktop entries that shadow the ones shipped by packages, so app launchers
# pick up local fixes (HiDPI scale factors, Wayland flags, extra instances).
# A file here wins over /usr/share/applications/<same name>.
APPS      := $(shell ls local-apps)
APPS_DIR  := ${HOME}/.local/share/applications

# RIME input-method patches, linked file by file rather than as a directory:
# the rest of the rime folder is generated or machine-local state (build/,
# *.userdb, user.yaml, installation.yaml, sync/) and must stay out of the repo.
RIME      := $(shell ls rime)
RIME_DIR  := ${HOME}/.local/share/fcitx5/rime

# Mail and calendar sync units, linked file by file: ~/.config/systemd/user is
# a real directory owned by other services and cannot be replaced by a symlink.
UNITS     := $(shell ls systemd)
UNITS_DIR := ${HOME}/.config/systemd/user

# Herdr config, linked file by file: ~/.config/herdr also holds the server
# sockets, logs, and session state, so the directory itself must stay local.
HERDR     := $(shell ls herdr)
HERDR_DIR := ${HOME}/.config/herdr

init::
	## make local applications folder
	@mkdir -pv $(APPS_DIR)
	## make rime config folder
	@mkdir -pv $(RIME_DIR)
	## make herdr config folder
	@mkdir -pv $(HERDR_DIR)
	## make mail folders
	@mkdir -pv $(UNITS_DIR) ${HOME}/.mail/gmail ${HOME}/.mail/pipi ${HOME}/.cache/mutt/gmail ${HOME}/.cache/mutt/pipi ${HOME}/.mail_attachments
	## make the vdir root vdirsyncer fills, one subtree per Google account
	@mkdir -pv ${HOME}/.calendars/gmail ${HOME}/.calendars/pipi

setup::
	## link desktop entry overrides
	@for item in $(APPS); do ln -vsfn $(BASE)/local-apps/$$item $(APPS_DIR)/$$item; done
	@update-desktop-database $(APPS_DIR)
	## link rime input-method patches
	@for item in $(RIME); do ln -vsfn $(BASE)/rime/$$item $(RIME_DIR)/$$item; done
	## link mail systemd units
	@for item in $(UNITS); do ln -vsfn $(BASE)/systemd/$$item $(UNITS_DIR)/$$item; done
	## link herdr config
	@for item in $(HERDR); do ln -vsfn $(BASE)/herdr/$$item $(HERDR_DIR)/$$item; done
