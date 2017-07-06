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
* IC Date - When it happened.  (defaults to the date when the scene started)
* Scene Set - (Optional) A temporary description added to the base room desc.

> **Tip:** Scene sets on empty rooms will be cleared periodically.

`scene/title [<#>=]<title>` - Sets the scene title.
`scene/summary [<#>=]<summary>` - Sets the scene summary.
`scene/icdate [<#>=]<icdate>` - Sets the scene date.
`scene/location [<#>=]=[<area>/]<location>` - Sets the scene location.
`scene/type [<#>=]<type>` - Sets the scene type.  `scene/types` lists types.
`scene/set <desc>` - Sets the scene in the current room.  Leave blank to clear.

> **Tip:** If your location name matches a grid location, the desc will be copied over.  You can use Area/Room for the location name to distinguish between rooms with the same name in different areas.

## Participants

The log system automatically tracks who participated in the scene.  Sometimes, though, you'll be emitting a character from another character (spoofing them).  You can attribute individual poses to different people through the Web Portal.  If you want to just replace all instances of one character with another, you can use the scene spoof command.  For example, if you had emitted Bob from Harry throughout the log, you can switch all of Harry's poses to Bob.  

`scene/spoof <#>=<original char>/<new char>`

> **Tip:** A spoof replacement can only be done on completed logs.