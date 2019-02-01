---
toc: Scenes
summary: Starting scenes.
order: 2
aliases:
- scene join
- scene stop
- scene end
- scene privacy
- scene location
- scene title
- scene summary
- scene date
- scene set
---
# Scenes
**Do `qr scene` to see a quick reference of all scene commands.**

The scenes system:

* Creates temprooms for places not on the grid.
* Advertises your scene as open so others know they're welcome to join.
* Captures a log of poses, skill rolls and combat messages without the OOC spam.
* Shares a log to the game's web portal. See [Scene Logging](/help/logging) for more.

## Starting a Scene

When you start a scene, you can create a temporary room or start one in the room you're in.  Temp rooms are automatically recycled when the scene ends.

`scene/start` - Starts a scene in your current room.
`scene/start [<area>/]<location name>=<private/open/watchable>` - Starts a scene in a temp room.

> **Tip:** If your location name matches a grid location, the desc will be copied over.  You can use Area/Room for the location name to distinguish between rooms with the same name in different areas.

A scene can be open (anyone's invited), private (only those invited should join or view), or watchable (only those invited should join, but anyone can view on the web portal). Open and Watchable scenes are visible on the web portal while active, and Private scenes are not. You can set a scene Private and still share the log afterwards.

`scene/privacy [<#>=]<private/open/watchable>` - Changes the privacy level.

> **Tip:** Admins and Storytellers with the `manage_scenes` permission can stop and delete other people's scenes, as well as pose into Watchable or Open scenes. They cannot see or pose into Private scenes.


## Finding & Joining Scenes

`scenes` - Lists active scenes.
`scene <#>.` - See a scene's information.
`scene/join <#>` - Joins an open scene.
`meetme <list of names>` - Invites others to join your private or watchable scene.
`scene/invite <name>[=<scene num>]` - Invites someone to a private or watchable scene.
`scene/uninvite <name>[=<scene num>]` - Withdraws an invitation.

## Setting Scene Info

You can control several properties about the scene.  These are used for [Scene Logging](/help/logging) and to advise the participants about what's going on.

`scene/title [<#>=]<title>` - Sets the scene title.
`scene/summary [<#>=]<summary>` - Sets the scene summary.
`scene/icdate [<#>=]<icdate>` - Sets the scene IC date. Defaults to today's date.
`scene/location [<#>=]=[<area>/]<location>` - Sets the scene location. Defaults to the room you are in.
`scene/type [<#>=]<type>` - Sets the scene type.  `scene/types` lists types. Defaults to social.
`scene/set <desc>` - Sets the scene in the current room and adds a temporary message to the desc, so that new players can refer to it.  Leave blank to clear.

## Stopping a Scene

You should stop a scene when it's over.  Scenes with empty rooms will be stopped automatically at some point.  The scene organizer can also delete a scene.  If you accidentally stop a scene, you can restart it in a temp room.

`scene/stop [<#>]` - Stops a scene and recycles the room (if it was a temporary one).
`scene/delete <#>` - Deletes a scene.
`scene/restart <#>` - Restarts a scene.

> **Tip:** Admins and Storytellers with the `manage_scenes` permission can stop and delete other people's scenes.

## Logging and Poses

The scene system starts a scene log automatically.  To disable this, or for more help with scene logs, including the pose editing commands, see [Scene Logging](/help/logging).
