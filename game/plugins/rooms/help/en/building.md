---
toc: ~admin~ Building
summary: Creating rooms.
aliases:
- build
- open
- rooms
- dig
- link
- unlink
- icstart
---
# Creating Rooms

> **Permission Required:** These commands require the Admin role or the build permission.

The MUSH grid consists of **Rooms** connected by **Exits**.  

## Creating a Room

You can create a room and optionally specify an outgoing exit (from your current room to the new one) and a return exit.

`build <name>[=<outgoing exit name>,<return exit name>]` - Creates a room.

> **Tip:** In Ares, exits have only a single name so there is no exit;alias;alias syntax.  Any exit named "O" is automatically aliased to "Out".  Also, if no specific 'out' exit exists, 'out' will simply take you out the first exit.

## Creating Exits

You can create additional exits using the 'open' command, and link exits to different rooms.  You can use the room database ID or a name (as long as the name is unambiguous).

`open <exit>[=<destination>]` - Creates an exit.

Once you have an exit, you can change the source or destination rooms that it's linked to.  

`link <exit>=<destination>` - Links an exit to a room.
`link/source <exit>=<source>` - Changes the exit's source.  The destination will be the current room.
`unlink <exit>` - Unlinks an exit from its destination.

> **Tip:** By default, the room description shows you the exit name and the name of its destionation, e.g. `[S] Town Square`.  You can change the destination name to something else just by giving the exit a description.

## Locking Exits

> **Permissions Required:** This command requires the Admin role or the 'build' permission.

Builders can also lock exits to a list of roles - for instance if you had a "rebel" role you could lock a secret rebel exit to "rebel admin" so only rebels and admins could use it.  Role locks are not limited to interior rooms; any exit can be locked.

`lock <exit>=<list of roles who are allowed in>`
`unlock <exit>`

## Finding Rooms

If you lose track of rooms you've created, you may need to use the database commands to find them again.  You can also use the database commands to destroy rooms or exits.  

`rooms`- Lists all rooms
`rooms <search>` - Search for rooms.

See the [Database Help](/help/database) file for more information.

## Special Rooms

The game knows about three special rooms:  

* The Welcome Room, where all new characters start.
* The Offstage (or OOC) Room, where all characters go when they go offstage/ooc.
* The IC Start room, where characters go the very first time they go onstage/ic.

Never mess with the first two.  If you do, you'll have to fiddle with code to tell the game where the new rooms are.

The IC Start room can be changed to any room with the command:  `icstart/set <room>`