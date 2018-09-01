---
toc: ~admin~ Managing the Game
summary: Creating admin-only player notes.
aliases:
- anote
- admin_note
---
# Admin Notes

Admins with the `manage_notes` permission can set notes on players that are only visible to other admins.  These notes are stored separately from the player-managed notes that they set themselves.

`notes <player>` - Shows a player's admin notes.
`note/add <player>=<note name>/<text>` - Create or update an admin note.
`note/delete <player>=<note name>` - Deletes a note.