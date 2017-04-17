---
toc: Managing Game
summary: Idle sweeping old characters.
---
The idle system lets you sweep the database for players who haven't logged in for awhile, so you can decide what to do with them.

We recommend that idled-out players be kept around *if* they've been approved.  They're part of the IC world.  They might come back, and allowing their name to be re-used could mess up the game wiki references.  Database space should not be an issue unless your game is ginormous. (If it is, you can always purge people later.)

## Idle Sweep

There are several idle actions available:

    Destroy - Get rid of them.  This is the default for unapproved characters.
    NPC - Mark that they're a NPC.  This is the default for approved characters.
    Gone - Mark that they've left the IC area.
    Dead - Mark that they're dead.
    Roster - Put them on the roster.
    Warn - Notify them they're in danger of idling out.
    Nothing - Give them a pass until next time.
    Reset - Clear their idle status.

`idle/start` - Builds up a list of idle players.
`idle/action <name>=<action>` - Decides what to do with someone.
        Note: If someone isn't already on the list, this will add them.
`idle/queue` - Review everyone's actions.
`idle/execute` - Takes care of the actions and posts a summary to the BBS.

`idle/set <name>=<status>` - Sets someone's status without running through the idle queue 
    or making a post.  Status can only be Gone, Dead or Nothing.  There are separate commands
    for putting someone on/off the roster (help roster) or making them a NPC (help npc).

## Roster

`roster/add <name>=<contact>` - Adds someone to the roster.  Contact is optional.
`roster/update <name>=<contact>` - Updates contact info on roster.  
        Leave blank to clear.
`roster/remove <name>` - Removes someone from the roster.

