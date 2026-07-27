include dotbase/base.mk

# Desktop entries that shadow the ones shipped by packages, so app launchers
# pick up local fixes (HiDPI scale factors, Wayland flags, extra instances).
# A file here wins over /usr/share/applications/<same name>.
APPS      := $(shell ls local-apps)
APPS_DIR  := ${HOME}/.local/share/applications

init::
	## make local applications folder
	@mkdir -pv $(APPS_DIR)

setup::
	## link desktop entry overrides
	@for item in $(APPS); do ln -vsfn $(BASE)/local-apps/$$item $(APPS_DIR)/$$item; done
	@update-desktop-database $(APPS_DIR)
