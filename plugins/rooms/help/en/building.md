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
# Creating Rooms

> **Permission Required:** These commands require the Admin role or the build permission.

For a general overview of building in Ares, see the aresmush.com [Building tutorial](https://aresmush.com/tutorials/manage/building.html).

## Building a Room

You can create a room and optionally specify an outgoing exit (from your current room to the new one) and a return exit.

`build <name>[=<outgoing exit name>,<return exit name>]` - Creates a room.

## Creating Exits

You can create additional exits using the 'open' command, and link exits to different rooms.  You can use the room database ID or a name (as long as the name is unambiguous).  See "Finding Rooms and Exits" below for more info on database IDs.

`open <exit>[=<destination>]` - Creates an exit.

Once you have an exit, you can change the source or destination rooms that it's linked to.  These commands accept an exit name or database ID. You'll need to use the ID if there are multiple exits in the room with the same name.  See "Finding Rooms and Exits" below for more info on database IDs.

`link <exit>=<destination>` - Links an exit to a room.
`link/source <exit>=<source>` - Changes the exit's source.  The destination will be the current room.
`unlink <exit>` - Unlinks an exit from its destination.

## Exit Aliases

Ares has several navigational cues that make exit aliases largely unnecessary.  If you need them, though, Ares exits can have a *single* alias, which you can set using the alias command:

`alias <exit name>=<exit alias>`

> **Tip:** Any exit named "O" is automatically aliased to "Out".  Also, if no specific 'out' exit exists, 'out' will simply take you out the first exit it can find.

## Exit Descriptions

By default, the room description shows you the exit name and the name of its destination, e.g. `[S] Town Square`.  You can change the destination name to something else just by giving the exit a short description.

`shortdesc <exit name>=<short description>`

## Locked Exits

For help with exit locks, see [Locks](/help/lock).

## Finding Rooms and Exits

If you lose track of rooms you've created, you may need to use these search commands to find them again.

`rooms`- Lists all rooms
`rooms <search>` - Search for rooms.
  
Sometimes you'll also need to know the database ID for an exit in your room.

`exits` - Lists all exits in your current room.

## Destroying Rooms and Exits

The destroy command will destroy a room or exit.  You can use 'here' or the name of the object.  If you accidentally create multiple exits with the same name in a single room, you'll need to use the database ID instead.  See "Finding Rooms and Exits" above.

`destroy here` - Destroys the room you're in and all its outgoing exits.  Incoming exits become unlinked.
`destroy <name or id>` - Destroys a room or exit by name or ID

## Special Rooms

The game has several special rooms, including the welcome room, offstage/ooc lounge, quiet room, and IC start room.  You can rename these rooms, but you cannot delete them.

The room where players go when they on onstage can be changed to any room with the command:  `icstart/set <room>`

## Describing Rooms

Use the [describe](/help/describe) command to give the room a description.  You can also give exits a description in case somebody looks at them.

Normally a room will show the destination name for exits (e.g. `[O] Town Square`), but you can override the destination name by setting a [shortdesc](/help/describe) for the exit.

[Vistas](/help/vistas) allow you to set up different pieces of the room description to be shown based on the time of day and season.

## Areas

Areas are used to group rooms together to represent different regions of the game.  See [Areas](/help/areas) for more information.

## Advanced Room Setup

See [Room Setup](/help/room_setup) for some more advanced room commands.