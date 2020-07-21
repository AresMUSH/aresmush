---
toc: 4 - Writing the Story
summary: Starting and editing scenes.
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
- repose
---
# Scenes
**Do `qr scene` to see a quick reference of all scene commands.**

While you can always do free-form RP on the grid or in the RP room, there are a variety of features available to you if you use the **Scenes** system to manage your RP scene.

> Learn about scenes in the [Scenes Tutorial](/help/scenes_tutorial).

## Viewing Scenes

`scenes` - Shows active scenes.
`scenes/open` - Shows only open and active scenes.
`scenes/all` - Lists all scenes you have access to.
`scenes/unshared` - Lists all scenes you have access to that haven't been shared yet.

`scene/home <home, work, ooc>` - Sets your preference for where you go after a scene in a temp room has been stopped.

## Starting  a Scene

`scene/start` - Starts a scene in your current room.
`scene/start [<area>/]<location name>=<private/open>` - Starts a scene in a temp room.
`scene/webstart [<area>/]<location name>=<private/open>` - Starts a scene that you intend to play on the web, and doesn't move you there.
`scene/limit [scene#]=<limit notice>` - Indicates that an open scene has some participation limit - by quantity, character type, etc.

> **Tip:** If your location name matches a grid location, the desc will be copied over.  You can use Area/Room for the location name to distinguish between rooms with the same name in different areas.

A scene can be open (anyone's invited), private (only those invited should join or view), or watchable (only those invited should join, but anyone can view on the web portal). Open and Watchable scenes are visible on the web portal while active, and Private scenes are not. You can set a scene Private and still share the log afterwards.

`scene/privacy [<#>=]<private/open/watchable>` - Changes the privacy level.

> **Tip:** Admins and Storytellers with the `manage_scenes` permission can stop and delete other people's scenes, as well as pose into Watchable or Open scenes. They cannot see or pose into Private scenes.


## Finding & Joining Scenes

`scenes` - Lists active scenes.
`scenes/open` - Lists active scenes that are marked as open to anyone.
`scene <#>.` - See a scene's information.
`scene/join <#>` - Joins an open scene.
`meetme <list of names>` - Invites others to join your private or watchable scene.
`scene/invite <name>[=<scene num>]` - Invites someone to a private or watchable scene.
`scene/uninvite <name>[=<scene num>]` - Withdraws an invitation.
`scene/leave` - Leaves a scene and returns to your designated scene home location.

## Editing Poses

`scene/replace <text in the form of an emit>` - Replaces your last pose.
`scene/typo <text in the form of an emit>` - Silent replace for small typos.
`scene/undo` - Removes your last pose.
`scene/emit <scene num>=<emit>` - Add a pose to a scene that isn't in your room.

## Stopping a Scene

`scene/stop [<#>]` - Stops a scene and recycles the room (if it was a temporary one).
`scene/delete <#>` - Deletes a scene.
`scene/restart <#>` - Restarts a scene.
`scene/home <home, work, ooc>` - Sets your scene home preference.

## Logging

`scene/share [scene #]` - Shares the log to the web portal.
`scene/unshare [scene #]` - Unshares a log.

## Disabling and Clearing the Log

`scene/disablelog [scene #]` - Stops logging. Note: This also clears any existing poses from the log.
`scene/clearlog [scene #]` - Clears current poses from the log but keeps logging enabled.
`scene/enablelog [scene #]` - Restarts logging. Note: This starts the scene fresh.

> **Note:** If the scene log is disabled, characters cannot join from the web portal.

## Setting Scene Info

`scene <#>` - Views scene info.
`scene/privacy [<#>=]<private/open>` - Changes the privacy level.
`scene/title [<#>=]<title>` - Sets the scene title.
`scene/summary [<#>=]<summary>` - Sets the scene summary.
`scene/icdate [<#>=]<icdate>` - Sets the scene date.
`scene/location [<#>=]=[<area>/]<location>` - Sets the scene location.
`scene/type [<#>=]<type>` - Sets the scene type.  `scene/types` lists types.
`scene/set <desc>` - Sets the scene in the current room.  Leave blank to clear.
`scene/addchar <#>=<char>` - Adds a participant to the scene log.
`scene/removechar <#>=<char>` - Removes a participant from the scene log.

> **Tip:** Admins and characters with the `manage_scenes` permission can edit other people's scenes.  However, they cannot read scenes unless they've been shared first.

## Reporting Abuse

If someone is behaving badly in a scene, you can bring it to the game admin's attention - along with an automatic, verified log of the scene (including OOC chat and any previously-edited or deleted poses).  

`scene/report <scene#>=<explanation>`
