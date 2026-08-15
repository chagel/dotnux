include dotbase/base.mk

# links.conf lists the directories whose contents are linked entry by entry into
# a destination that has to stay a real local directory. Adding one is a row
# there, not an edit here.
LINKS := links.conf
# every use skips blank lines and comments with the same guard
ROW   := NF && $$1 !~ /^\#/

# A directory under configs/ that is linked entry by entry must not ALSO be
# whole-directory linked by base.mk -- that would point ~/.config/<name> straight
# at the repo and leave the state living there nowhere to go. Recipes expand when
# the rule runs, so narrowing CONFIGS after the include still reaches base.mk's
# setup::.
#
# Only the first path component counts: CONFIGS holds the top-level names from
# `ls configs`, so a row reaching deeper (configs/omarchy/themed) still has to
# exclude the name base.mk would match on (omarchy).
PER_ENTRY := $(shell awk '$(ROW) && $$1 ~ /^configs\// {sub(/^configs\//, "", $$1); sub(/\/.*/, "", $$1); print $$1}' $(LINKS))
CONFIGS   := $(filter-out $(PER_ENTRY),$(CONFIGS))

init::
	## make every destination named in links.conf
	@awk '$(ROW) {print $$2}' $(LINKS) | while read -r dst; do \
		eval dst=$$dst; mkdir -pv "$$dst"; \
	done
	## make mail folders
	@mkdir -pv ${HOME}/.mail/gmail ${HOME}/.mail/pipi ${HOME}/.cache/mutt/gmail ${HOME}/.cache/mutt/pipi ${HOME}/.mail_attachments
	## make the vdir root vdirsyncer fills, one subtree per Google account
	@mkdir -pv ${HOME}/.calendars/gmail ${HOME}/.calendars/pipi

setup::
	## link the contents of each source in links.conf into its destination
	@awk '$(ROW) {print $$1, $$2}' $(LINKS) | while read -r src dst; do \
		eval dst=$$dst; \
		for item in $(BASE)/$$src/*; do \
			ln -vsfn "$$item" "$$dst/$$(basename "$$item")"; \
		done; \
	done
	## desktop entries are only picked up after the database is rebuilt
	@update-desktop-database ${HOME}/.local/share/applications
