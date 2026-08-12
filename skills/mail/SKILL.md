---
name: mail
description: "Search, read, triage, and draft replies to Mike's mail through notmuch. Use when the user asks about their email, inbox, a message or thread, who wrote about something, or wants mail tagged, summarised, or a reply drafted. This skill never sends mail -- drafts are handed to neomutt."
---

# Mail

Mail is fetched by `mbsync` into maildirs and indexed by `notmuch`. neomutt is the
human interface; this skill is the agent's, over the same index. Nothing here
sends mail: drafts are written to a file and opened in neomutt for Mike to send.

| Account | Address | Maildir |
| --- | --- | --- |
| `gmail` | chagel@gmail.com | `~/.mail/gmail` |
| `pipi` | mike@pipihosting.com | `~/.mail/pipi` |

`mbsync.timer` syncs every 5 minutes and reindexes afterwards. To force fresh
mail before answering a "did I get..." question:

```bash
systemctl --user start mbsync.service   # blocks until sync + notmuch new finish
```

## Ground yourself before querying

Tags and folders change; do not work from the lists in this file.

```bash
notmuch search --output=tags '*'
notmuch search --output=files --limit=1 'folder:/./'   # or: ls ~/.mail/*/
```

`maildir.synchronize_flags` is on, so tagging `unread`, `flagged`, `replied`,
`draft` or `passed` rewrites the maildir filename and **mbsync pushes that state
back to Gmail**. Those five tags are not local scratch space. Any other tag is.

## Query syntax

Prefixes: `from:` `to:` `subject:` `body:` `tag:` `folder:` `path:` `attachment:`
`mimetype:` `thread:` `id:` `date:`, combined with `and` `or` `not` `xor` and
parentheses. `*` wildcards work on most fields.

Dates take relative expressions, but **only with underscores**:

```bash
notmuch count 'date:2_weeks_ago..'      # works
notmuch count 'date:"2 weeks ago"..'    # Xapian exception
```

Also valid: `date:today..`, `date:yesterday..`, `date:last_month..`,
`date:1M..`, `date:friday..`, `date:2026-08-01..`.

## Reading without flooding context

Count first, then narrow, then read. The archive is thousands of messages and a
broad `notmuch show` will bury the actual task.

```bash
notmuch count <query>
notmuch search --format=json --limit=20 --sort=newest-first <query>
notmuch show --format=json --body=true --limit=3 <query>
```

Prefer `notmuch show --format=text` for a single thread you intend to summarise;
prefer `--format=json` when extracting fields. Use `--entire-thread=false` unless
the whole thread matters.

Attachments — list parts, then extract one:

```bash
notmuch show --format=json id:<msgid>            # parts carry numeric ids
notmuch show --part=2 --format=raw id:<msgid> > ~/.mail_attachments/<name>
```

## Tagging

Tagging is destructive and notmuch has no undo. **Dump the tags first**, always,
before any change touching more than one message:

```bash
mkdir -p "$HOME/.cache/notmuch"
notmuch dump --output="$HOME/.cache/notmuch/tags-$(date +%Y%m%d-%H%M%S).dump"
notmuch tag +receipt -inbox -- <query>          # note the -- before the query
```

Write `$HOME`, not `~`, after an `=`: Mike's shell is fish, which does not expand
a tilde there, and `--output=~/...` would silently create a directory named `~`.

To undo: `notmuch restore --input=<that file>`.

Show the user the `notmuch count` of a query before tagging on it, so the blast
radius is known in advance. For anything above ~50 messages, confirm first.

## Drafting a reply

`notmuch reply` builds the template with correct `From`, `To`, `In-Reply-To`,
`References` and a quoted body. Write it to a file, edit that file, hand it over:

```bash
mkdir -p "$HOME/.cache/mail-drafts"
notmuch reply id:<msgid> > "$HOME/.cache/mail-drafts/<slug>.eml"
# edit the body below the headers, then hand over:
neomutt -H ~/.cache/mail-drafts/<slug>.eml
```

Tell the user the exact `neomutt -H` command and let them send it. Do not run a
mail transport, do not write into `~/.mail/*/Drafts`, do not use `notmuch insert`
to stage outgoing mail — anything landing in a synced maildir reaches Google.

`notmuch address --output=recipients <query>` resolves who someone is when the
user names a person rather than an address.

## Rules

- Never send mail. There is no SMTP client configured for scripts, and adding one
  is a decision for Mike, not a step in a task.
- Never delete a message or move a maildir file. Untag `inbox` to archive.
- Quote what the mail actually says. Summarise, but do not infer intent that is
  not in the text, and name the message you are drawing from.
- Report counts honestly, including zero. A query returning nothing is ambiguous
  between "no such mail" and "wrong query" — say which you checked.
