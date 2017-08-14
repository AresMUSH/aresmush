---
toc: ~admin~ Managing the Game
summary: Idle sweeping old characters.
---
# Idle Sweeping Old Characters

> **Permission Required:** These commands require the Admin role or the permission: idle\_sweep

The idle system lets you sweep the database for players who haven't logged in for awhile, so you can decide what to do with them.

## Idle Sweep

There are several idle actions available:

    Destroy - Get rid of them.  This is the default for unapproved characters.
    Gone - Mark that they've left the IC area.
    NPC - Mark that they're a NPC. 
    Dead - Mark that they're dead.
    Roster - Put them on the roster.
    Warn - Notify them they're in danger of idling out.  This is the default for approved characters.
    Reset - Clear their idle status.

> **Tip:** We recommend that you **not** destroy idled-out players once they've been approved.  They're part of the IC world.  They might come back, and allowing their name to be re-used could mess up the game wiki references.  Database space should not be an issue unless your game is ginormous. (If it becomes a problem, you can always purge people at that point.)

[[help idle/start]]
[[help idle/action]]
[[help idle]]
[[help idle/execute]]
[[help idle/remove]]

## Setting Idle Status Directly

Sometimes you want to immediately idle someone out without going through the whole idle queue process.  You can do this with the `idle/set` command.  Only 'Dead' and 'Gone' are valid options here.  If you just want to mark someone as a NPC, use the [NPC](/help/npc) command.  To add or remove someone from the roster, use the [Roster](/help/manage_roster) commands.

[[help idle/set]]

## Rostered Characters

For help managing the roster, see [Managing the Roster](/help/roster_admin)