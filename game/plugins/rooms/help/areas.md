---
toc: Grid
summary: Areas and coordinates.
aliases:
- area
- grid
- roomtype
- zone
---
Rooms have several properties that you can set.  The `area` and `grid`` properties are used to help people get around.  They can be used in room descriptions and the 'where' command and such.  The `roomtype` property ties in with the 'status' system, to tell whether someone is in the IC or OOC zone.

`area <name>` - Sets the room area.  Leave name blank to clear.
`grid <x>=<y>` - Sets the grid coordinates.  Leave blank to clear.
        You can use letters or numbers (1,1) or (B,2)
`roomtype <IC, OOC or RPR>` - Sets a room as part of the IC, OOC or RPR (Roleplay Room) zone.
`foyer <on or off` - Marks whether a room is a foyer, like an apartment or the
        RP room hub.  Numbered exits will be shown in a special way.
