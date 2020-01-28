---
toc: ~admin~ Managing the Game
summary: Creating admin-only player notes.
aliases:
- anote
- admin_note
---
# Admin Notes

Admins with the `manage_notes` permission can set notes on players.  There are three sections of notes:

* Player - a player's personal notes, not visible to admins.
* Shared - notes shared between admin and the player.
* Admin - notes visible only to admins

`notes <player>` - Views someone's notes.
`notes/set <player>/<section>=<notes>` - Sets notes.
`notes/edit <player>/<section>` - Grabs notes into your edit buffer.  (See [Edit Feature](/help/edit)).
