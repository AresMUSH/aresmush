---
toc: ~admin~ Building
summary: Managing room areas.
---
# Managing Areas

> **Permission Required:** These commands require the Admin role or the build permission.

Areas are used to group rooms together to represent different regions of the game.  For example, you might use areas to represent different worlds (if your game spans the galaxy) or different districts within a single city.

## Viewing Areas

You can view a list of all areas and details for any given one.

`areas` - Lists all areas.
`area [<area name>]` - Shows details for an area.  Defaults to your current area.

## Creating Areas

Areas are automatically created when you assign an area to a room using `area/set` as explained in the [Building](/help/building) commands.  You can also manually create/edit/delete them.

> Note: If you want to include an ASCII map, include it in 'pre' tags to make it format correctly.  For example:  

    [[pre]]  :-)  [[/pre]]

`area/create <name>[=<description>]` - Creates a new area.
`area/update <name>=<description>` - Updates an existing area.  Leave description blank to clear it.
`area/delete <name>` - Deletes an area.
`area/rename <name>=<new name>` - Renames an area.  You can use this to change capitalization on the name as well as changing the name itself.

If your client supports the [Edit Feature](/help/edit), you can use the edit command to grab an area description into the input buffer.

`area/edit <name>` - Grabs an area description into your edit buffer.

## Area Parents

You can create a hierarchy of areas by assigning a 'parent' to each area.

For example, you might have an area "New York" as the parent of areas named "Harlem" and "Brooklyn".  Individual rooms would then be assigned to either Harlem, Brooklyn, or (for rooms that are in neither) New York.

`area/parent <area>=<parent area>` - Sets the parent for an area.  Leave blank to clear it.