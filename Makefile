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
	## Restore shell.json only when it is missing. This one is a copy, not a
	## link: every mutation goes through omarchy-shell-config, which writes a
	## temp file and `mv`s it over $$HOME/.config/omarchy/shell.json: a literal
	## path it never resolves, so a link there would be replaced by a regular
	## file on the first `omarchy plugin enable` or `omarchy bar move`. That
	## also makes the live file the one with the newest truth, so setup must
	## never overwrite it -- this is the recovery path for a lost file or an
	## `omarchy refresh shell`. Run `make shell-capture` to record changes.
	@if [ -f ${HOME}/.config/omarchy/shell.json ]; then \
		echo "shell.json present, left alone (make shell-capture to record it)"; \
	else \
		install -Dm644 $(BASE)/configs/omarchy/shell.json ${HOME}/.config/omarchy/shell.json; \
		echo "restored shell.json from the repo"; \
	fi

# The other direction, always explicit: shell.json is edited in place by
# omarchy's own commands, so the repo copy is a snapshot rather than the source
# of truth. Take a snapshot once the bar is how you want it.
shell-capture:
	@cp -v ${HOME}/.config/omarchy/shell.json $(BASE)/configs/omarchy/shell.json

# Check the invariants in docs/omarchy.md against the installed Omarchy. Also
# runs from configs/omarchy/hooks/post-update.d after every `omarchy update`,
# which is the point: upstream moving is reported, not discovered later.
audit:
	@$(BASE)/scripts/omarchy-audit

# Re-record the upstream hashes once the reported changes have been reviewed.
audit-accept:
	@$(BASE)/scripts/omarchy-audit --accept
