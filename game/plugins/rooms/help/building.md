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

Rooms have several properties that you can set.  The `area` and `grid`` properties are used to help people get around.  They can be used in room descriptions and the 'where' command and such.  The `roomtype` property ties in with the 'status' system, to tell whether someone is in the IC or OOC zone.

`area <name>` - Sets the room area.  Leave name blank to clear.
`grid <x>=<y>` - Sets the grid coordinates.  Leave blank to clear.
        You can use letters or numbers (1,1) or (B,2)
`roomtype <IC or OOC>` - Sets a room as part of the IC or OOC zone.
        Note:  For RP Rooms, we recommend setting them "IC" so that people in them 
        show up as RPing rather than showing up as OOC.  But it's your choice.
`foyer <on or off` - Marks whether a room is a foyer, like an apartment or the
        RP room hub.  Numbered exits will be shown in a special way.
