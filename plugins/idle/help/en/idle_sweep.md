---
toc: ~admin~ Managing the Game
summary: Idle sweeping old characters.
aliases:
- manage_idle
---
# Idle Sweeping Old Characters

**These commands require the Admin role or the permission: manage\_idle.**

## Idle Sweep

See the [idle sweep tutorial](https://aresmush.com/tutorials/manage/idle.html) for an overview of how the idle sweep works and some important tips.

`idle/start` - Builds up a list of idle players.
`idle` - Review everyone's actions.
`idle/action <name>=<action>` - Decides what to do with someone.
        Note: If someone isn't already on the list, this will add them.
        You can also use idle/gone, idle/warn, etc.

There are several idle actions available:
        Destroy - Get rid of them.  This is the default for unapproved characters.
        Gone - Mark that they've left the IC area.
        NPC - Mark that they're a NPC.
        Dead - Mark that they're dead.
        Roster - Put them on the roster.
        Warn - Notify them they're in danger of idling out.  This is the default for approved characters.
        None - Clear someone's idle status.

`idle/remove <name>` - Removes someone from the list.
`idle/execute` - Takes care of the actions and posts a summary to the BBS.
`idle/note <name>=<note>` - Adds a note about what happened to them.

## Idle Preview

You can get a preview of someone's recommended idle action, and view their lastwill.

`idle/preview <name>` - View idle information without adding someone to the idle queue.

## Setting Idle Status Directly

`idle/set <name>=<status>` - Sets someone's status without running through the idle queue.
`npc <name>=<on or off>` - Admin-only command to mark a character as a staff-run NPC.
`roster/add <name>=<contact>` - Adds someone to the roster.  Contact is optional.
