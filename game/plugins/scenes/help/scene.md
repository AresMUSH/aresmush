---
topic: scene
toc: Scenes
summary: Starting scenes.
categories:
- main
plugin: scenes
aliases:
- scenes
---

The scenes system lets you spawn a room for a scene.  You can indicate whether the scene is public (meaning anyone is invited to join) or public.

`scene/start <location>=<private/public>` - Starts a scene.
`scenes` - Lists scenes.

To join a scene, you can get a meetme from a participant or use the join scene command.

`scene/join <#>` - Joins a scene.

You can create a "scene set" on a room to augment the usual description with scene details.  This can be used on regular rooms too - not just scene rooms.

`scene/set <desc>` - Sets the scene.  Leave blank to clear.

The scene's organizer can stop the scene and change the privacy setting.

`scene/privacy <#>=<private/public>` - Changes the privacy level.
`scene/stop <#>` - Stops a scene and recycles the room.