---
toc: ~admin~ Managing the Game
summary: Managing maps.
---
# Managing Maps

> **Permission Required:** These commands require the Admin role or the permission: manage\_maps

Admins and characters with permissions can manage the in-game maps.

## Creating Maps

You can create in-game maps using markdown text.

> Note: If you want to include an ASCII map, include it in 'pre' tags to make it format correctly.  For example:  `[[pre]]: - )[[/pre]]`.

`map/create <name>=<map text>` - Creates a new map.
`map/update <name>=<map text>` - Updates an existing map.
`map/delete <name>` - Deletes a map.

If your client supports the [Edit Feature](/help/edit), you can use the edit command to grab a map into the input buffer.

`map/edit <name>` - Grabs a map into your edit buffer.

By default, a map is used for a single area matching its name.  So a map named 'offstage' would be used for the 'offstage' area.  You can change which map an area uses:

`map/area <area name>=<map name>`

Leave the map name blank to clear it.