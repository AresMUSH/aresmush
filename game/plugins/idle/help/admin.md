---
toc: ~admin~ Managing Game
summary: Idle sweeping old characters.
---
# Idle Sweeping Old Characters

> **Permission Required:** These commands require the Admin role or the permission: idle\_sweep

The idle system lets you sweep the database for players who haven't logged in for awhile, so you can decide what to do with them.

## Idle Sweep

There are several idle actions available:

    Destroy - Get rid of them.  This is the default for unapproved characters.
    Gone - Mark that they've left the IC area. This is the default for approved characters.
    NPC - Mark that they're a NPC. 
    Dead - Mark that they're dead.
    Roster - Put them on the roster.
    Warn - Notify them they're in danger of idling out.
    Nothing - Give them a pass until next time.
    Reset - Clear their idle status.

> **Tip:** We recommend that you not destroy idled-out players once they've been approved.  They're part of the IC world.  They might come back, and allowing their name to be re-used could mess up the game wiki references.  Database space should not be an issue unless your game is ginormous. (If it becomes a problem, you can always purge people at that point.)

`idle/start` - Builds up a list of idle players.
`idle/action <name>=<action>` - Decides what to do with someone.
        Note: If someone isn't already on the list, this will add them.
`idle/queue` - Review everyone's actions.
`idle/execute` - Takes care of the actions and posts a summary to the BBS.

`idle/set <name>=<status>` - Sets someone's status without running through the idle queue 
    or making a post.  Status can only be Gone, Dead or Nothing.  There are separate commands
    for putting someone on/off the roster (help roster) or making them a NPC (help npc).

## Roster

Admin command allow someone with the `manage_roster` command to add and remove people from the roster.

`roster/add <name>=<contact>` - Adds someone to the roster.  Contact is optional.
`roster/remove <name>` - Removes someone from the roster.

You can optionally include a contact person and notes about the roster character.

`roster/contact <name>=<contact>` - Updates contact info on roster.  
`roster/notes <name>=<notes>` - Adds roster notes.

Roster characters normally are just claimed with no fanfare using the `roster/claim` command.  For special characters, you may want to require people to talk to the contact person and/or submit an application.  Characters marked as 'restricted' can't be claimed via a simple command.

`roster/restrict <name>=<on or off>` - Restricts claims.

When someone wants to claim a restricted character, staff will have to manually remove them from the roster, reset their password, and send the password to the new player somehow.