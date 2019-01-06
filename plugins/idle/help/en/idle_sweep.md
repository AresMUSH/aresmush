---
toc: ~admin~ Managing the Game
summary: Idle sweeping old characters.
---
# Idle Sweeping Old Characters

> **Permission Required:** These commands require the Admin role or the permission: manage\_idle.

The idle system lets you sweep the database for players who haven't logged in for awhile, so you can decide what to do with them.

## Idle Sweep

There are several idle actions available:

    Destroy - Get rid of them.  This is the default for unapproved characters.
    Gone - Mark that they've left the IC area.
    NPC - Mark that they're a NPC. 
    Dead - Mark that they're dead.
    Roster - Put them on the roster.
    Warn - Notify them they're in danger of idling out.  This is the default for approved characters.

> **Tip:** We recommend that you **not** destroy idled-out players once they've been approved.  They're part of the IC world.  They might come back, and allowing their name to be re-used can cause confusion.  Database space should really not be an issue.  You could have thousands of PCs and barely make a dent in disk space on modern servers.

`idle/start` - Builds up a list of idle players.
`idle` - Review everyone's actions.
`idle/action <name>=<action>` - Decides what to do with someone.
        Note: If someone isn't already on the list, this will add them.
        You can also use idle/gone, idle/warn, etc.
`idle/remove <name>` - Removes someone from the list.
`idle/execute` - Takes care of the actions and posts a summary to the BBS.

## Idle Preview

You can get a preview of someone's recommended idle action, and view their lastwill.

`idle/preview <name>` - View idle information without adding someone to the idle queue.
  
## Setting Idle Status Directly

Sometimes you want to immediately idle someone out without going through the whole idle queue process.  You can do this with the `idle/set` command.  Only 'Dead' and 'Gone' are valid options here.  If you just want to mark someone as a NPC, use the [NPC](/help/npc) command.  To add or remove someone from the roster, use the [Roster](/help/manage_roster) commands.   You can also clear someone's idle status by setting it to 'None'.

`idle/set <name>=<status>` - Sets someone's status without running through the idle queue.

## Rostered Characters

For help managing the roster, see [Managing the Roster](/help/manage_roster)