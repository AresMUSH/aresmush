---
toc: Scenes
summary: Creating and Joining scenes.
aliases:
- scene join
- scene joining
- scene stop
- scene end
- scene privacy
---

# Creating and Joining a Scene

When you start a scene, it takes you to a new room exclusively for that scene.

`scene/start <title>[=<private/public>]` - Starts a scene.
`scene/stop [<#>]` - Stops a scene and recycles the room.

The title can be temporary until you think of a good one.

> **Tip:** Admins and characters with the `manage_scenes` permission can stop other people's scenes.

## Joining Scenes

To join a public scene, you can use the scene/join command.  To join a public scene, you'll need a meetme (see [Meetme](/help/rooms/meetme).

`scenes` - Lists scenes.
`scene/join <#>` - Joins a scene.

## Scene Privacy

Scenes are public by default.  The scene's organizer can change the privacy setting. 

`scene/privacy [<#>=]<private/public>` - Changes the privacy level.
