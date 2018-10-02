---
toc: ~admin~ Building
summary: Managing room areas.
---
# Managing Areas

Areas are used to group rooms together to represent different regions of the game.

## Viewing Areas

You can view a list of all areas and details for any given one.

`areas` - Lists all areas.
`area [<area name>]` - Shows details for an area.  Defaults to your current area.

**These commands require the Admin role or the build permission.**
## Creating Areas

Areas are automatically created when you assign an area to a room using `area/set`.  You can also manually create/edit/delete them.

`area/create <name>[=<description>]` - Creates a new area.
`area/update <name>=<description>` - Updates an existing area.  Leave description blank to clear it.
`area/delete <name>` - Deletes an area.
`area/edit <name>` - Grabs an area description into your edit buffer. See [edit](/help/edit).

## Area Parents

You can create a hierarchy of areas by assigning a 'parent' to each area.

For example, you might have an area "New York" as the parent of areas named "Harlem" and "Brooklyn".  Individual rooms would then be assigned to either Harlem, Brooklyn, or (for rooms that are in neither) New York.

`area/parent <area>=<parent area>` - Sets the parent for an area.  Leave blank to clear it.
