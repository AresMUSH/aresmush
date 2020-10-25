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

While you can always do free-form RP on the grid or in the RP room, there are a variety of features available to you if you use the **Scenes** system to manage your RP scene. 

> Learn about scenes in the [Scenes Tutorial](/help/scenes_tutorial).

## Viewing Scenes

`scenes` - Shows active scenes.
`scenes/open` - Shows only open scenes and ones you've been invited to.
`scenes/unshared` - Lists all scenes you have access to that haven't been shared yet.
`scenes/all` - Lists all scenes you have access to.

## Starting  a Scene

`scene/start` - Starts a scene in your current room.
`scene/start [<area>/]<location name>=<private/open>` - Starts a scene in a temp room.
`scene/webstart [<area>/]<location name>=<private/open>` - Starts a scene that you intend to play on the web, and doesn't move you there.
`scene/notes [scene#]=<notes>` - Notes for those joining a scene, like participation limit - by quantity, character type, etc. or other special considerations.

## Joining and Leaving Scenes

`scenes` - Lists active scenes.
`scenes/open` - Lists active scenes that are marked as open to anyone.
`scene/join <#>` - Joins a scene.
`scene/invite <names>[=<scene num>]` - Invites someone to a private scene.
`scene/uninvite <names>[=<scene num>]` - Withdraws an invitation.
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

## Repose and Logging

`scene/repose [# of poses to show]` - Quick log catch-up of your current scene.
`scene/log [scene #]` - Spam yourself with the entire log.

`scene/share [scene #]` - Shares the log to the web portal.
`scene/unshare [scene #]` - Unshares a log.

## Disabling and Clearing the Log

`scene/disablelog [scene #]` - Stops logging. Note: This also clears any existing poses from the log.
`scene/clearlog [scene #]` - Clears current poses from the log but keeps logging enabled.
`scene/enablelog [scene #]` - Restarts logging. Note: This starts the scene fresh.

> **Note:** If the scene log is disabled, characters cannot join from the web portal.

## Setting Scene Info

`scene <#>` - Views scene info, without poses.
`scene/info <#>` - Views scene info, without poses.
`scene/privacy [<#>=]<private/open>` - Changes the privacy level.
`scene/title [<#>=]<title>` - Sets the scene title.
`scene/summary [<#>=]<summary>` - Sets the scene summary.
`scene/icdate [<#>=]<icdate>` - Sets the scene date.
`scene/location [<#>=]=[<area>/]<location>` - Sets the scene location.
`scene/type [<#>=]<type>` - Sets the scene type.  `scene/types` lists types.
`scene/pacing [<#=]<pacing>` - Sets the scene pacing. Traditional, Distracted, or Asynchronous. (you can abbreviate the name)
`scene/warning [<#=]<warning>` - Sets a content warning on the scene.
`scene/set <desc>` - Sets the scene in the current room.  Leave blank to clear.
`scene/addchar <#>=<names>` - Adds participants to the scene log. Normally used when someone poses from an alt but you want the other char added too.
`scene/removechar <#>=<names>` - Removes participants from the scene log. Normally used when someone poses from the wrong char and you need to remove them.

> **Tip:** Admins and characters with the `manage_scenes` permission can edit other people's scenes that have been shared.  However, they cannot read scenes unless they've been shared first.

## Reporting Abuse

If someone is behaving badly in a scene, you can bring it to the game admin's attention - along with an automatic, verified log of the scene (including OOC chat and any previously-edited or deleted poses).  

`scene/report <scene#>=<explanation>`