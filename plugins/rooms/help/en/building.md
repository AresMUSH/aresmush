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

> **These commands require the Admin role or the build permission.**

`build <name>[=<outgoing exit name>,<return exit name>]` - Creates a room.

 **Tip:** In Ares, exits have only a single name so there is no exit;alias;alias syntax.  Any exit named "O" is automatically aliased to "Out".  Also, if no specific 'out' exit exists, 'out' will simply take you out the first exit.

`open <exit>[=<destination>]` - Creates an exit.

`link <exit>=<destination>` - Links an exit to a room.
`link/source <exit>=<source>` - Changes the exit's source.  The destination will be the current room.
`unlink <exit>` - Unlinks an exit from its destination.

 **Tip:** By default, the room description shows you the exit name and the name of its destionation, e.g. `[S] Town Square`.  You can change the destination name to something else just by giving the exit a description.

## Locking Exits

Exits can be locked to a list of roles.

`lock <exit>=<list of roles allowed in>`
`unlock <exit>`

## Finding Rooms

If you lose track of rooms you've created, you may need to use the database commands to find them again.  You can also use the database commands to destroy rooms or exits.  

`rooms`- Lists all rooms
`rooms <search>` - Search for rooms.

See the [Database Help](/help/database) file for more information.

## Describing Rooms

`describe <room>=<description> - Describes a room`
`shortdesc <exit>=<description> - Describes an exit`

Normally a room will show the destination name for exits (e.g. `[O] Town Square`), but you can override the destination name by setting a shortdesc for the exit.

[Vistas](/help/vistas) allow you to set up different pieces of the room description to be shown based on the time of day and season.

## Special Rooms

The game knows about three special rooms:  

* The Welcome Room, where all new characters start.
* The Offstage (or OOC) Room, where all characters go when they go offstage/ooc.
* The IC Start room, where characters go the very first time they go onstage/ic.

The room where players go when they on onstage can be changed to any room with the command:  `icstart/set <room>`

The welcome and offstage rooms cannot be moved or deleted, but you can rename them or update their descriptions as you see fit.

## Advanced Room Setup
See [Room Setup](/help/room_setup) for some more advanced room commands.
