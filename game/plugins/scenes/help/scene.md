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

`scene/start <location>=<private/public>` - Starts a scene.  The location can be the name of an existing room (in which case the description will be copied over) or a custom name.

To join a scene, you can get a meetme from a participant or use the join scene command.

`scenes` - Lists scenes.
`scene/join <#>` - Joins a scene.

The scene's organizer can stop the scene and change the privacy setting.  If no scene number is specified, it will operate on your current room.

`scene/privacy [<#>=]<private/public>` - Changes the privacy level.
`scene/stop [<#>]` - Stops a scene and recycles the room.