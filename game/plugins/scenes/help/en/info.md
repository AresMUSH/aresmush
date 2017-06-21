---
toc: Scenes
summary: Setting scene info.
---
# Scene Info

You can control several properties about the scene:

* Location - Setting the scene's location copies over the description from another room.
* Title - Scene title.
* Scene Set - A temporary description added to the base room desc.
* Summary - A summary of the scene (for the scene log archive - see [Scene Logging](/help/scenes/logging)).

> **Tip:** Scene sets can be used on regular rooms too - not just scene rooms.  Scene sets on empty rooms will be cleared periodically.

`scene/title [<#>=]<title>` - Sets the scene title.
`scene/summary [<#>=]<summary>` - Sets the scene summary.
`scene/location [<#>=]=[<area>/]<location>` - Sets the scene location.
`scene/set <desc>` - Sets the scene in the current room.  Leave blank to clear.