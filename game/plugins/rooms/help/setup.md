---
toc: Grid
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

The room area shows up on the 'where' list to show you which part of the grid someone is in.

`area <name>` - Sets the room area.  Leave name blank to clear.

## Grid Coordinates

Grid coordinates can help people navigate the grid.  You can use whatever coordinate system you want - for example letters or numbers (1,1) or (B,2).

`grid <x>=<y>` - Sets the grid coordinates.  Leave blank to clear.

## Room Type

The `roomtype` property ties in with the 'status' system, to tell whether someone is in the IC or OOC zone.  RPR is for roleplay rooms, which are counted as IC but are technically not on the grid.

`roomtype <IC, OOC or RPR>` - Sets a room as part of the IC, OOC or RPR (Roleplay Room) zone.


`foyer <on or off` - Marks whether a room is a foyer, like an apartment or the
        RP room hub.  Numbered exits will be shown in a special way.

## Room Owners

By default, only people with builder privileges can modify the description on a room.  However, builders can assign an 'owner' to a room, who is also allowed to describe it.

`owner <name>` - Sets a room owner.  Leave blank to reset.