---
toc: ~admin~ Managing the Game
summary: Idle sweeping old characters.
aliases:
- manage_idle
---
# Idle Sweeping Old Characters

> **Permission Required:** These commands require the Admin role or the permission: manage\_idle.

The idle system lets you sweep the database for players who haven't logged in for awhile, so you can decide what to do with them.

## Idle Workflow

The idle sweep is not performed automatically. By default, the game will remind you to do it monthly, but you can configure that.  When you do an idle sweep, the general workflow is:

1. Start the idle sweep with `idle/start`.
2. Remove anyone who shouldn't be affected (either because of known vacations or other immunity) with `idle/remove`.
3. Set an action to take on everyone else (or accept the default action) with `idle/action`.  Add an optional note with `idle/note`.
4. Execute the idle sweep with `idle/execute`.

There are several idle actions you can take with someone who comes up on the idle sweep:

* Warn - Notify them they're in danger of idling out.  This is the default for approved characters.
* Destroy - Get rid of them.  This is the default for unapproved characters.
* Gone - Mark that they've left the IC area.
* NPC - Mark that they're a NPC. 
* Dead - Mark that they're dead.
* Roster - Put them on the roster.

> **Note:** We recommend that you **not** destroy idled-out players once they've been approved and played in scenes.  They're part of the IC world.  They might come back, and allowing their name to be re-used can cause confusion.  Plus, removing them will make all messages from them appear from "Author Deleted" and will remove them from scenes.  It's generally best to keep them around.

Warning someone sends them a mail and posts to the forum alerting them that they're in danger of idling out.  The next time they come up on the idle sweep, it will alert you that they've already been warned once. You can choose to warn them again (and keep doing so indefinitely) or switch to another action.

The system also posts a list of everyone who's idled out to the forum so people know how to react ICly.

Except for warn, the other actions also reset their password so they cannot just log back in and act like nothing happened.  To reclaim their character they will have to go through the game admin.

## Setting Idle Status Directly

Sometimes you want to immediately idle someone out without going through the whole idle queue process.  You can do this with the `idle/set` command.  Only 'None', 'Dead' and 'Gone' are valid options here.  You can also clear someone's idle status by setting it to 'None'.

## Protected Roles

You can't mark certain individuals as permanently safe from the idle sweep, but you can protect people with certain roles by specifying those roles in the idle config settings.

## Rostered Characters

For help managing the roster, see [Managing the Roster](/help/manage_roster)

## Command Reference

Here are the idle sweep commands for quick reference.  The system is explained in more detail below.

`idle/start` - Builds up a list of idle players.
`idle` - Review everyone's actions.
`idle/action <name>=<action>` - Decides what to do with someone.  Note: If someone isn't already on the list, this will add them.  You can also use idle/gone, idle/warn, etc.
`idle/remove <list of names>` - Removes someone from the list.
`idle/execute` - Takes care of the actions and posts a summary to the BBS.
`idle/note <name>=<note>` - Adds a note about what happened to them.

`idle/preview <name>` - View idle information without adding someone to the idle queue.
`idle/set <name>=<status>` - Sets someone's status without running through the idle queue.

