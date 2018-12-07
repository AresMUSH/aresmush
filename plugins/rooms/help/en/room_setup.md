---
toc: ~admin~ Building
summary: Room setup.
aliases:
- area
- grid
- roomtype
- zone
- owner
---
# Room Setup

> **Permission Required:** These commands require the Admin role or the build permission.

Once a room is built, there are several properties you may wish to set.  All of these properties are optional.

## Areas

Areas are used to group rooms together to represent different regions of the game.  See [Areas](/help/areas).

## Grid Coordinates

Grid coordinates can help people navigate the grid.  You can use whatever coordinate system you want - for example letters or numbers (1,1) or (B,2).

`grid [<room name>=]<x>/<y>` - Sets the grid coordinates.  Leave blank to clear.

## Room Type

The `roomtype` property ties in with the 'status' system, to tell whether someone is in the IC or OOC zone.  RPR is for roleplay rooms, which are counted as IC but are technically not on the grid.

`roomtype [<room name>=]<IC, OOC or RPR>` - Sets a room as part of the IC, OOC or RPR (Roleplay Room) zone.


`foyer <on or off` - Marks whether a room is a foyer, like an apartment or the
        RP room hub.  Numbered exits will be shown in a special way.

## Room Owners

By default, only people with builder privileges can modify the description on a room.  However, builders can assign 'owners' to a room, who are also allowed to describe it.

`owners [<room name>=]<list of names>` - Sets room owners.  Leave blank to reset.