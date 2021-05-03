---
toc: 4 - Writing the Story
summary: Understanding the scene system.
order: 1
tutorial: true
aliases:
- plot
---

# Scenes

Scenes are the primary way RP takes place on Spirit Lake. You can RP in scenes on the game or in a web browser using the web portal. You can RP in several scenes at once - though it is good manners to only take on as many scenes as you can respond to in the expected amount of time (see scene pacing below).

While you can always do free-form RP on the grid, there are a variety of features available to you if you use the **Scenes** system to manage your RP scene.  Some features that the scenes system provides:

* Creating temprooms for places not on the grid or for private scenes in on-grid rooms.
* Advertising your scene as open so others know they're welcome to join.
* Capturing a log of poses, skill rolls and combat messages without the OOC spam.
* Sharing a log to the game's web portal.

[[toc]]

## Viewing a List of Scenes

You can see what scenes are going on through the web portal (typically under Play -> Active Scenes) or the `scenes` command. Your scenes will show first, followed by open scenes and then all other active scenes.

![Scenes Page Screenshot](https://aresmush.com/images/help-images/scenes.png)

> **Tip:** Once you've joined scenes, you can switch between them easily on the [Play](/play) page on the web portal.

You can also view your stopped scenes under '[Your Unshare Scenes](/scenes-unshared).'

## Starting a Scene

When you start a scene, you can create a temporary room or start one in the room you're in.  Scenes started on the web portal always use a temp room.  Temp rooms are automatically recycled when the scene ends.

`scene/start` - Starts a scene in your current room.
`scene/start [<area>/]<location name>=<private/open>` - Starts a scene in a temp room. Use 'here' to start a scene using your current room as the location.
`txt/newscene <name>=<message>` - Start a new text scene.

> **Tip:** If your location name matches a grid location, the desc will be copied over.  You can use Area/Room for the location name to distinguish between rooms with the same name in different areas.

## Scene Privacy

A scene can either be open (anyone's invited) or private.  Scenes on the grid are open by default.  The scene's organizer can change the privacy setting.

> **Note:** No one can see the context of a private scene except the participants. Ares has no built-in commands to support admins spying on players.  Just as with any online service, though, **any** data transmitted to the server and/or stored in the database is ultimately accessible to the game owner and anyone they choose to share it with.  See [Privacy](/help/privacy).

An open scene can include a note if there are any special considerations - like if a scene is open only to certain types of characters (Mages only, Nature mages, etc.), only a certain number of characters, or even to note that players can just come and watch. This is an advisory only--the scene is still open in all meaningful respects, it just alerts players that there may be some conditions to participating.

`scene/privacy [<#>=]<private/open>` - Changes the privacy level.
`scene/notes [scene#]=<notes>` - Notes for those joining a scene, like participation limit - by quantity, character type, etc. or other special considerations.

## Scene Pacing

MUSHes have traditionally been focused around live, synchronous RP, with players all being online together. With the web portal, Ares supports more varied playstyles. You can specify a **Pacing** for your scene to let other players know what to expect before they join.

If your scene is anything other than 'Traditional,' it's important to be sure everyone knows and understands before the scene begins.

* **Traditional**: Live, synchronous RP with most poses coming 5-15 minutes apart. (Default Setting)
* **Distracted**: RP that is still synchronous with most poses 5-15 minutes apart, but with occasional longer times between poses due to work or other distractions. Often referred to as 'work slow.'
* **Asynchronous**: RP with poses coming in at various times 30+ minutes apart, possibly in different timezones or schedules or even over multiple days. It's a good idea to discuss pose timing with your partners in asynchronous scenes, so that everyone has the same expectations.

If you wish to add extra detail about your scene's pacing, use the scene notes field.

`scene/notes [scene#]=<notes>` - Notes for those joining a scene, like participation limit - by quantity, character type, etc. or other special considerations.

## Joining Scenes

To join an open scene, you can use the `scene/join` command or join on the [web portal](/scenes).  To join a private scene, you'll need a scene invitation or a [meetme](/help/meetme).

> **Tip:** When you're playing via the MU client, you can only pose to a scene in the room you're in.  On the web portal, you can join and pose to any number of scenes at once.

## Posing

During the scene, you will use [Poses](/help/posing_tutorial) to write your part of the story.

### Pose Order

You can use [Pose Order](/help/pose_order) to help keep track of whose turn it is. This is a guide to help people take turns equitably, and is not meant as a strict turn order. If the scene is large, the participants may agree to set poses to 3-person rounds.

You can turn off the pose order reminder, or mute it until your next login.

`pose/ordertype <normal, 3-per>` - Set the pose order type.
`pose/nudge <on, off or gag>` - Controls whether the game tells you when it's your turn.

### Editing and Deleting poses

You can edit and delete your poses through the web portal. From a MU client, you can also amend or replace your **prior pose** using `scene/replace` or `scene/typo`.  The typo version corrects it in the log but doesn't add a notification. It should only be used for minor corrections that don't change the content of the pose.

### Posing From Multiple characters

In the web portal, you can pose from any character in the scene that you control.  That would include the character you're logged in with, any alts that are linked to your Ares player handle, and (for storytellers with the 'can_control_npcs' permission) NPCs.  Alts and NPCs must be added to the scene (by clicking Edit and updating the participant list) before you can pose from them.

![Live Scene Page Screenshot](https://aresmush.com/images/help-images/scene-live.png)

## Scene Logging

The scenes system captures a RP log automatically for you.  The log will contain poses, skill rolls and combat results.  OOC remarks will be captured while the scene is in progress but deleted once it's shared.  Other OOC spam (pages, channels, help text) will not be included.

During the scene, you can refer back to the log for a quick catch-up if you joined late or missed poses.  You can also capture the full, clean log from either the web portal or the `scene/log` command.

## Stopping a Scene

You should stop a scene when it's over, either from the portal menu or using `scene/stop`.  Scenes with no activity will be stopped automatically at some point.  If a scene is inadvertently stopped, you can find it on your [unshared scenes](/scenes-unshared) page and restart it.

When a scene in a temp room stops, characters in that room are normally sent back to the Offstage lounge.  You can instead choose to be sent to your character's home or workplace (if you've set one with the home or work command) using the `scene/home` command.

## Sharing a Scene

When a scene is over, you can choose to share the scene on the web portal.  Shared scenes are viewable by everyone and included on your character's personal scene archive on their profile page.

> **Note:** Unshared scenes will be deleted at some point (determined by the game settings), so if you don't intend to share the scene you should be sure to download the scene log. You cannot delete unshared scenes manually.

### Plots

Through the web portal, you can create "plots", which are a way to organize related scenes.  When editing a scene, you can select which plot it's a part of.  The plot page on the web portal will list all scenes you've linked to the plot. Plots can also have a description and a storyteller, who acts as a contact person for plot-related questions.

### Creatures & Portals

Through the web portal, you can select which creatures or portals are featured in the scene. The creature and portal pages will list all relevant scenes.

### NPCs

If your scene involves a recurring named NPC, use a tag to mark their presence. This makes it easy to find all logs featuring that NPC.

`npc:npc_name` - Use this tag to indicate the presence of a recurring NPC.

## Command Reference

[Scene Commands](/help/scenes)
[Posing](/help/posing)
[Pose Order](/help/pose_order)
[Pose Formatting](/help/pose_format)
[Texting](/help/txt)
[Out-of-Character Remarks](/help/ooc)
