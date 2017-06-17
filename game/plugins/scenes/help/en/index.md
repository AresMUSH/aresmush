---
toc: Scenes
summary: Starting scenes.
---
# Scenes

The scenes system lets you spawn a room for a scene.  You can indicate whether the scene is public (meaning anyone is invited to join) or private.

## Starting and Stopping a Scene

`scene/start <location>=<private/public>` - Starts a scene.  The location can be the name of an existing room (in which case the description will be copied over) or a custom name.
`scene/stop [<#>]` - Stops a scene and recycles the room.

Admins and characters with the `manage_scenes` permission can stop other people's scenes.

## Joining Scenes

To join a scene, you can get a meetme from a participant or use the join scene command.

`scenes` - Lists scenes.
`scene/join <#>` - Joins a scene.

## Scene Privacy

Scenes are public by default.  The scene's organizer can change the privacy setting. 

`scene/privacy [<#>=]<private/public>` - Changes the privacy level.

## Scene Sets

You can also create a "scene set" on a room to augment the usual description with scene details.  This can be used on regular rooms too - not just scene rooms.  Scene sets on empty rooms will be cleared periodically.

`scene/set <desc>` - Sets the scene.  Leave blank to clear.

## Other Topics

[Configuring the Scene System](/help/scenes/config)