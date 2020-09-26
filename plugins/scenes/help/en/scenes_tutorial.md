---
toc: 4 - Writing the Story
summary: Understanding the scene system.
order: 1
tutorial: true
aliases:
- plot
---

# Scenes

While you can always do free-form RP on the grid or in the RP room, there are a variety of features available to you if you use the **Scenes** system to manage your RP scene.  Some features that the scenes system provides:

* Creating temprooms for private scenes or places not on the grid.
* Advertising your scene as open so others know they're welcome to join.
* Capture a log of poses, skill rolls and combat messages without the OOC spam.
* Share a log easily to the game's web portal.

[[toc]]

## Viewing Scenes

You can see what scenes are going on through the web portal (typically under Play -> Active Scenes) or the `scenes` command.

![Scenes Page Screenshot](https://aresmush.com/images/help-images/scenes.png)

> **Tip:** Once you've joined scenes, you can switch between them easily on the My Scenes page on the web portal.

## Starting a Scene

When you start a scene, you can create a temporary room or start one in the room you're in.  Scenes started on the web portal always use a temp room.  Temp rooms are automatically recycled when the scene ends.

> **Tip:** If your location name matches a grid location, the desc will be copied over.  You can use Area/Room for the location name to distinguish between rooms with the same name in different areas.

## Scene Privacy

A scene can either be open (anyone's invited) or private.  Scenes on the grid are open by default and scenes in RP Rooms private by default.  The scene's organizer can change the privacy setting. 

> **Note:** Ares has no built-in commands to support admins spying on players.  Just as with any online service, though, **any** data transmitted to the server and/or stored in the database is ultimately accessible to the game owner and anyone they choose to share it with.  See [Privacy](/help/privacy).

An open scene can include a note if there are any special considerations - like if a scene is open only to certain types of characters (Imperials only, Viper Pilots only, etc.), only a certain number of characters, or even to note that players can just come and watch. This is an advisory only--the scene is still open in all meaningful respects, it just alerts players that there may be some conditions to participating.

## Scene Pacing

MUSHes have traditionally been focused around live, synchronous RP, with players all being online together. With the web portal, Ares supports more varied playstyles. You can specify a **Pacing** for your scene to let other players know what to expect before they join.

* **Traditional**: Live, synchronous RP with poses coming minutes apart. (Default Setting)
* **Distracted**: RP that is still synchronous, but with longer time between poses due to work or other distractions.
* **Asynchronous**: RP with poses coming in at various times, possibly in different timezones or schedules, or even over multiple days.

If you wish to add extra detail about your scene's pacing, use the scene notes field.

## Joining Scenes

To join an open scene, you can use the `scene/join` command or join on the web portal.  To join a private scene, you'll need a scene invitation or a [meetme](/help/meetme). 

> **Tip:** When you're playing via the MU client, you can only pose to a scene in the room you're in.  On the web portal, you can join and pose to any number of scenes at once.

## Posing

During the scene, you will use [Poses](/help/posing_tutorial) to write your part of the story.

You can use [Pose Order](/help/pose_order) to help keep track of whose turn it is. This is a guide to help people take turns equitably, and is not meant as a strict turn order.

You can edit and delete your poses through the web portal. From a MU client, you can also amend or replace your **prior pose** using `scene/replace` or `scene/typo`.  The typo version corrects it in the log but doesn't add a notification.

In the web portal, you can pose from any character in the scene that you control.  That would include the character you're logged in with, any alts that are linked to your Ares player handle, and (for storytellers with the 'can_control_npcs' permission) NPCs.  Alts and NPCs must be added to the scene (by clicking Edit and updating the participant list) before you can pose from them.

![Live Scene Page Screenshot](https://aresmush.com/images/help-images/scene-live.png)

## Scene Logging

The scenes system captures a RP log automatically for you.  The log will contain poses, skill rolls and combat results.  OOC remarks will be captured while the scene is in progress but deleted once it's shared.  Other OOC spam (pages, channels, help text) will not be included.

During the scene, you can refer back to the log for a quick catch-up if you joined late or missed poses.  You can also capture the full, clean log from either the web portal or the `scene/log` command.

## Stopping a Scene

You should stop a scene when it's over, either from the portal menu or using `scene/stop`.  Scenes with no activity will be stopped automatically at some point.  If a scene is inadvertently stopped, you can restart it in a temp room.

When a scene in a temp room stops, characters in that room are normally sent back to the Offstage lounge.  You can instead choose to be sent to your character's home or workplace (if you've set one with the home or work command) using the `scene/home` command.

## Sharing a Scene

When a scene is over, you can choose to share the scene on the web portal.  Shared scenes are viewable by everyone and included on your character's personal scene archive on their profile page.

> **Note:** Unshared scenes will be deleted at some point (determined by the game settings), so if you don't intend to share the scene you should be sure to download the scene log.

## Plots

Through the web portal, you can create "plots", which are a way to organize related scenes.  When editing a scene, you can select which plot it's a part of.  The plot page on the web portal will list all scenes you've linked to the plot. Plots can also have a description and a storyteller, who acts as a contact person for plot-related questions.

## Command Reference

[Scene Commands](/help/scenes)
[Posing](/help/posing)
[Pose Order](/help/pose_order)
[Pose Formatting](/help/pose_format)
[Out-of-Character Remarks](/help/ooc)