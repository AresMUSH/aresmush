---
toc: ~admin~ Building
summary: Creating rooms.
order: 1
aliases:
- build
- open
- rooms
- dig
- link
- unlink
- icstart
---
# Requesting a Build
You can request that a room or series of rooms be built for many reasons, including a place of business, a home, or a location for a plot.
`build/request <room name>=<details>`- Request a room be built. Include where it should be built and any other needed info. If you need several rooms built, you can do a single request.

# Creating Rooms

> **These commands require the Admin role or the build permission.**

`build <name>[=<outgoing exit name>,<return exit name>]` - Creates a room.

## Creating Exits

You can create additional exits using the 'open' command, and link exits to different rooms.  You can use the room database ID or a name (as long as the name is unambiguous).

`open <exit>[=<destination>]` - Creates an exit.

`link <exit>=<destination>` - Links an exit to a room.
`link/source <exit>=<source>` - Changes the exit's source.  The destination will be the current room.
`unlink <exit>` - Unlinks an exit from its destination.

> **Tip:** By default, the room description shows you the exit name and the name of its destionation, e.g. `[S] Town Square`.  You can change the destination name to something else just by giving the exit a short description using the `shortdesc` command (see [Descriptions](/help/descriptions)).

## Exit Aliases

Ares has several navigational cues that make exit aliases largely unnecessary.  If you need them, though, Ares exits can have a *single* alias, which you can set using the alias command:

`alias <exit name>=<exit alias>`

> **Tip:** Any exit named "O" is automatically aliased to "Out".  Also, if no specific 'out' exit exists, 'out' will simply take you out the first exit it can find.

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

## Describing Rooms

Use the [describe](/help/describe) command to give the room a description.  You can also give exits a description in case somebody looks at them.

Normally a room will show the destination name for exits (e.g. `[O] Town Square`), but you can override the destination name by setting a [shortdesc](/help/describe) for the exit.

[Vistas](/help/vistas) allow you to set up different pieces of the room description to be shown based on the time of day and season.

## Areas

Areas are used to group rooms together to represent different regions of the game.  See [Areas](/help/areas) for more information.

## Advanced Room Setup
See [Room Setup](/help/room_setup) for some more advanced room commands.
