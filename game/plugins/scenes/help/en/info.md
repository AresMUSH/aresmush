---
toc: Scenes
summary: Setting scene info.
---
# Scene Info

You can control several properties about the scene.  These are used for [Scene Logging](/help/scenes/logging) and to advise the participants about what's going on.

* Location - Setting the scene's location copies over the description from another room.
* Title - Scene title.
* Summary - A summary of the scene.
* Scene Type - What kind of scene it is.
* Scene Set - (Optional) A temporary description added to the base room desc.

> **Tip:** Scene sets on empty rooms will be cleared periodically.

`scene/title [<#>=]<title>` - Sets the scene title.
`scene/summary [<#>=]<summary>` - Sets the scene summary.
`scene/location [<#>=]=[<area>/]<location>` - Sets the scene location.
`scene/type [<#>=]<type>` - Sets the scene type.  `scene/types` lists types.
`scene/set <desc>` - Sets the scene in the current room.  Leave blank to clear.

> **Tip:** If your location name matches a grid location, the desc will be copied over.  You can use Area/Room for the location name to distinguish between rooms with the same name in different areas.