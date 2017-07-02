---
toc: Scenes
summary: Creating and Joining scenes.
aliases:
- scene join
- scene stop
- scene end
- scene privacy
---

# Creating and Joining a Scene

When you start a scene, you can create a temporary room or start one in the room you're in.  Temp rooms are automatically recycled when the scene ends.

`scene/start` - Starts a scene in your current room.
`scene/start <location name>=<private/public>` - Starts a scene in a temp room.
`scene/stop [<#>]` - Stops a scene and recycles the room (if it was a temporary one).

> **Tip:** Admins and characters with the `manage_scenes` permission can stop other people's scenes.

## Scene Privacy

A scene can either be public (anyone's invited) or private.  Scenes on the grid are public by default.  Scenes in RP rooms are private.  The scene's organizer can change the privacy setting. 

`scene/privacy [<#>=]<private/public>` - Changes the privacy level.

> **Tip:** It's rude to create a private scene in a public room on the main grid. Use a RP room or temp room instead.

## Joining Scenes

To join a public scene, you can use the scene/join command.  To join a private scene, you'll need a meetme (see [Meetme](/help/rooms/meetme).

`scenes` - Lists scenes.
`scene/join <#>` - Joins a scene.
