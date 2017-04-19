---
toc: Grid
summary: Creating rooms.
aliases:
- build
- open
- rooms
- dig
- link
- unlink
- area
- grid
- roomtype
- zone
---
# Creating Rooms

> **Permission Required:** These commands require the Admin role or the build permission.

The MUSH grid consists of **Rooms** connected by **Exits**.  

## Creating a Room

You can create a room and optionally specify an outgoing exit (from your current room to the new one) and a return exit.

`build <name>[=<outgoing exit name>,<return exit name>]` - Creates a room.

> **Tip:** In Ares, exits have only a single name so there is no exit;alias;alias syntax.  Any exit named "O" is automatically aliased to "Out".

## Creating Exits

You can create additional exits using the 'open' command, and link exits to different rooms.  You can use the room database ID or a name (as long as the name is unambiguous).

`open <exit>[=<destination>]` - Creates an exit.
`link <exit>=<destination>` - Links an exit to a room.
`unlink <exit>` - Unlinks an exit from its destination.

## Finding Rooms

If you lose track of rooms you've created, you may need to use the database commands to find them again.  You can also use the database commands to destroy rooms or exits.  See the [Database Help](/help/manage/database) file.