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

# shell.json is a copy rather than a link: omarchy-shell-config renders each
# mutation to a temp file and `mv`s it over a literal path, which would replace
# a link with a regular file on the first `omarchy plugin enable`.
#
# It ships with the system and omarchy-refresh-config overwrites it in place,
# so it is never missing -- there is nothing for setup to decide, and both
# directions are a command you run on purpose.
shell-capture:
	@cp -v ${HOME}/.config/omarchy/shell.json $(BASE)/configs/omarchy/shell.json

shell-restore:
	@cp -v $(BASE)/configs/omarchy/shell.json ${HOME}/.config/omarchy/shell.json
	@omarchy-restart-shell

# Check the one rule in docs/omarchy.md that breaks silently. Also runs from
# configs/omarchy/hooks/post-update.d after every `omarchy update`.
audit:
	@$(BASE)/scripts/omarchy-audit

