---
topic: building
toc: Grid
summary: Building the grid.
categories:
- admin
- builder
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
plugin: rooms
---
The MUSH grid consists of **Rooms** connected by **Exits**.  Admin with appropriate permissions can create these using the build and open commands.

`build <name>[=<outgoing exit name>,<return exit name>]` - Creates a room.
`open <exit>[=<destination>]` - Creates an exit.
`link <exit>=<destination>` - Links an exit to a room.
`unlink <exit>` - Unlinks an exit from its destination.

Note: In Ares, exits have only a single name so there is no exit;alias;alias syntax.  Any exit named "O" is automatically aliased to "Out".

Exits can be locked to a list of roles - for instance if you had a "rebel" role you could lock a secret rebel exit to "rebel admin" so only rebels and admins could use it.  To unlock an exit, set the role lock to "everyone".

`lock <exit>=<list of roles>`

If you create rooms without exits, you may need to use the database commands to find them again.  You can also use the database commands to destroy rooms or exits.  See the help files on `destroy` and `find`.