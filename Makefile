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

init::
	## make local applications folder
	@mkdir -pv $(APPS_DIR)
	## make rime config folder
	@mkdir -pv $(RIME_DIR)

setup::
	## link desktop entry overrides
	@for item in $(APPS); do ln -vsfn $(BASE)/local-apps/$$item $(APPS_DIR)/$$item; done
	@update-desktop-database $(APPS_DIR)
	## link rime input-method patches
	@for item in $(RIME); do ln -vsfn $(BASE)/rime/$$item $(RIME_DIR)/$$item; done
