---
toc: 4 - Writing the Story
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

While you can always do free-form RP on the grid or in the RP room, there are a variety of features available to you if you use the **Scenes** system to manage your RP scene.  Some features that the scenes system provides:

* Creating temprooms for private scenes or places not on the grid.
* Advertising your scene as open so others know they're welcome to join.
* Capture a log of poses, skill rolls and combat messages without the OOC spam.
* Share a log to the game's web portal and/or wiki (if enabled).

The scene system automatically maintains a log of the scene, including combat and skill roll messages.   See [Scene Logging](/help/logging) for more information.

## Starting  a Scene

When you start a scene, you can create a temporary room or start one in the room you're in.  Temp rooms are automatically recycled when the scene ends.

`scene/start` - Starts a scene in your current room.
`scene/start [<area>/]<location name>=<private/open>` - Starts a scene in a temp room.
`scene/webstart [<area>/]<location name>=<private/open>` - Starts a scene that you intend to play on the web, and doesn't move you there.

> **Tip:** If your location name matches a grid location, the desc will be copied over.  You can use Area/Room for the location name to distinguish between rooms with the same name in different areas.

## Scene Privacy

A scene can either be open (anyone's invited) or private.  Scenes on the grid are open by default.  Scenes in RP rooms are private.  The scene's organizer can change the privacy setting. 

`scene/privacy [<#>=]<private/open>` - Changes the privacy level.

> **Tip:** It's rude to create a private scene in a public room on the main grid. Use a RP room or temp room instead.

## Joining and Leaving Scenes

To join an open scene, you can use the scene/join command.  To join a private scene, you'll need a scene invitation or a [meetme](/help/meetme). 

`scenes` - Lists active scenes.
`scenes/open` - Lists active scenes that are marked as open to anyone.
`scene/join <#>` - Joins a scene.
`scene/invite <name>[=<scene num>]` - Invites someone to a private scene.
`scene/uninvite <name>[=<scene num>]` - Withdraws an invitation.
  
You can leave a scene by exiting the room or going offstage or by using the scene/leave command to return to your designated scene/home (described in Stopping a Scene below).

`scene/leave` - Leaves a scene and returns to your designated scene home location.

## Setting Scene Info

You can control several properties about the scene.  These are used for [Scene Logging](/help/logging) and to advise the participants about what's going on.

You can see the current scene info by typing `scene <#>.`

`scene/title [<#>=]<title>` - Sets the scene title.
`scene/summary [<#>=]<summary>` - Sets the scene summary.
`scene/icdate [<#>=]<icdate>` - Sets the scene date.
`scene/location [<#>=]=[<area>/]<location>` - Sets the scene location.
`scene/type [<#>=]<type>` - Sets the scene type.  `scene/types` lists types.
`scene/set <desc>` - Sets the scene in the current room.  Leave blank to clear.

> **Tip:** If your location name matches a grid location, the desc will be copied over.  You can use Area/Room for the location name to distinguish between rooms with the same name in different areas.

## Stopping a Scene

You should stop a scene when it's over.  Scenes with empty rooms will be stopped automatically at some point.  The scene organizer can also delete a scene.  If you accidentally stop a scene, you can restart it in a temp room.

`scene/stop [<#>]` - Stops a scene and recycles the room (if it was a temporary one).
`scene/delete <#>` - Deletes a scene.
`scene/restart <#>` - Restarts a scene.

> **Tip:** Admins and characters with the `manage_scenes` permission can stop and delete other people's scenes.

When a scene in a temp room stops, characters are normally sent back to the Offstage lounge.  You can instead choose to be sent to your character's home or workplace, if you've set one with the home or work command.

`scene/home <home, work, ooc>` - Sets your scene home preference.

## Logging and Poses

The scene system starts a scene log automatically.  For more help, see [Scene Logging](/help/logging).