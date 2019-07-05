---
toc: ~admin~ Managing the Game
summary: Idle sweeping old characters.
aliases:
- manage_idle
---
# Idle Sweeping Old Characters

> **Permission Required:** These commands require the Admin role or the permission: manage\_idle.

The idle system lets you sweep the database for players who haven't logged in for awhile, so you can decide what to do with them.

## Idle Sweep

See the [idle sweep tutorial](https://aresmush.com/tutorials/manage/idle.html) for an overview of how the idle sweep works and some important tips.

`idle/start` - Builds up a list of idle players.
`idle` - Review everyone's actions.
`idle/action <name>=<action>` - Decides what to do with someone.
        Note: If someone isn't already on the list, this will add them.
        You can also use idle/gone, idle/warn, etc.
`idle/remove <list of names>` - Removes someone from the list.
`idle/execute` - Takes care of the actions and posts a summary to the BBS.
`idle/note <name>=<note>` - Adds a note about what happened to them.

## Idle Preview

You can get a preview of someone's recommended idle action, and view their lastwill.

`idle/preview <name>` - View idle information without adding someone to the idle queue.
  
## Setting Idle Status Directly

Sometimes you want to immediately idle someone out without going through the whole idle queue process.  You can do this with the `idle/set` command.  Only 'None', 'Dead' and 'Gone' are valid options here.  If you just want to mark someone as a NPC, use the [NPC](/help/npc) command.  To add or remove someone from the roster, use the [Roster](/help/manage_roster) commands.   You can also clear someone's idle status by setting it to 'None'.

`idle/set <name>=<status>` - Sets someone's status without running through the idle queue.

## Rostered Characters

For help managing the roster, see [Managing the Roster](/help/manage_roster)