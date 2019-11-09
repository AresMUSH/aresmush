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
- area
- grid
- roomtype
- zone
- owner
- foyer
- owners
---
# Requesting a Build
You can request that a room or series of rooms be built for many reasons, including a place of business, a home, or a location for a plot.
`build/request <room name>=<details>`- Request a room be built. Include where it should be built and any other needed info. If you need several rooms built, you can do a single request.

> Learn about building in the [Building Tutorial](/help/building_tutorial).

# Creating Rooms

> **These commands require the Admin role or the build permission.**

`build <name>[=<outgoing exit name>,<return exit name>]` - Creates a room.

## Creating Exits

`open <exit>[=<destination>]` - Creates an exit.

`link <exit>=<destination>` - Links an exit to a room.
`link/source <exit>=<source>` - Changes the exit's source.  The destination will be the current room.
`unlink <exit>` - Unlinks an exit from its destination.

`alias <exit name>=<exit alias>` - Sets a **single** alias for the exit.
`shortdesc <exit name>=<short description>` - Sets the destination description that appears next to the exit name.

> **Tip:** Any exit named "O" is automatically aliased to "Out".  Also, if no specific 'out' exit exists, 'out' will simply take you out the first exit it can find.

## Locking Exits

For help with exit locks, see [Locks](/help/lock).

## Finding Rooms and Exits

`rooms`- Lists all rooms
`rooms <search>` - Search for rooms.
`exits` - Lists all exits in your current room.

## Destroying Rooms and Exits

`destroy here` - Destroys the room you're in and all its incoming and outgoing exits.
`destroy <name or id>` - Destroys a room or exit by name or ID

## Areas

Areas are used to group rooms together to represent different regions of the game.  See [Areas](/help/areas) for more information.

## Advanced Room Setup

`grid [<room name>=]<x>/<y>` - Sets the grid coordinates.  Leave blank to clear.
`roomtype [<room name>=]<IC, OOC or RPR>` - Sets a room as part of the IC, OOC or RPR (Roleplay Room) zone.
`foyer <on or off` - Marks whether a room is a foyer, like an apartment or the RP room hub.  Numbered exits will be shown in a special way.
`icstart <room name>` - Resets the IC starting location.

## Owners

`owners [<room or character name>]` - Searches for room owners.  Leave blank to use current room.
`owners/set [<room name>=]<list of names>` - Sets room owners.  Leave blank to reset.
