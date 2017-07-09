---
toc: Scenes
summary: Editing scene poses.
aliases:
- scene spoof
- scene edit
- scene replace
---
# Editing Scene Logs

The [Scene Log](/help/scenes/logging) automatically captures poses from a scene (unless you turn it off).  Sometimes these poses have problems.

## Editing a Pose

You can edit and delete your poses through the Web Portal, and even attribute them to other characters (handy if you're emitting from one of your alts).  

For a quick correction, you can also replace your **previous pose** with a corrected one.  Format it like an emit:

`scene/replace <text in the form of an emit>`

You can also just delete your last pose completely.

`scene/undo`

## Participants

The log system automatically tracks who participated in the scene.  You can edit this through the web portal.

Sometimes, though, you'll be emitting a character from another character (spoofing them). If you want to just replace all instances of one character with another, you can use the scene spoof command.  For example, if you had emitted Bob from Harry throughout the log, you can switch all of Harry's poses to Bob.  

`scene/spoof <#>=<original char>/<new char>`

> **Tip:** The spoof replacement only applies to past emits, not future ones.  It is best to use it on a completed log.