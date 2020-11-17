---
toc: ~admin~ Building
summary: Managing room areas.
---
# Managing Areas

Areas are used to group rooms together to represent different regions of the game. 

> **Permission Required:** These commands require the Admin role or the `build` permission.

## Viewing Areas

`areas` - Lists all areas.
`area [<area name>]` - Shows details for an area.  Defaults to your current area.

## Creating and Editing Areas

`area/create <name>[=<description>]` - Creates a new area.
`area/update <name>=<description>` - Updates an existing area.  Leave description blank to clear it.
`area/delete <name>` - Deletes an area.
`area/rename <name>=<new name>` - Renames an area.  You can use this to change capitalization on the name as well as changing the name itself.
`area/edit <name>` - Grabs an area description into your edit buffer. (see [Edit Feature](/help/edit))
`area/parent <area>=<parent area>` - Sets the parent for an area.  Leave blank to clear it.

## Setting Areas

`area/set [<room>]=<area>` - Sets a room's area. Defaults to the room you're in if you don't specify a name.