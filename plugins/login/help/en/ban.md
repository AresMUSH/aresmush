---
toc: ~admin~ Managing the Game
summary: Banning trolls.
aliases:
- ban
- siteban
- sitelock
---

# Banning Trolls

> **Permission Required:** These commands require the Admin role.

Banning a site doesn't target a particular character, but a particular IP or hostname.  It prevents ANY characters from logging in, being created, or accessing the web portal from that site.  Be aware that this could potentially block _other_ players logging in from the same ISP.

The `ban` command will block a player's IP address. It also boots them if they're online, resets their password, and unlinks their player handle. It does this for all of their alts too.

`ban <name>=<reason>` - Bans a player's site, including all their alts.
`ban/list` - Shows the ban list.
`ban/delete <#>`  - Deletes an entry from the banned list.

You can also manually add a site to the banned list without specifying a particular player. You can use this to ban people preemptively, or to manually tweak the host/IP on someone's ban (after deleting the old one).

`ban/add <site>=<note>` - Adds an entry to the banned list.

A few notes about `ban/add`:

- This is a ‘contains’ search, so listing verizon.net would block 123.456.pool.verizon.net and 678.901.pool.verizon.net, etc.  Wildcards (like *) are NOT supported. 
- Be wary of making the match too broad. You don’t want to block an entire region of the country.
- Using ban/add doesn't do all of the player-specific actions that the regular ban command does.

