---
toc: ~admin~ Managing the Game
summary: Managing maps.
---
# Managing Maps

> **Permission Required:** These commands require the Admin role or the permission: manage\_maps

Admins and characters with permissions can manage the in-game maps.

## Creating Maps

You can create in-game maps using ASCII art and text.

`map/create <name>=<map text>` - Creates a new map.
`map/update <name>=<map text>` - Updates an existing map.
`map/delete <name>` - Deletes a map.

By default, a map is used for a single area matching its name.  So a map named 'offstage' would be used for the 'offstage' area.  You can assign maps to muliple areas using:

`map/areas <name>=<areas>` - Assign a map to multiple areas.  
        Use comma-separated area names since they can contain multiple words.