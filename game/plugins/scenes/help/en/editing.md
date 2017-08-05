---
toc: Scenes
summary: Editing scene poses.
aliases:
- scene spoof
- scene edit
- scene replace
- scene undo
---
# Editing Scene Logs

The [Scene Log](/help/scenes/logging) automatically captures poses from a scene (unless you turn it off).  Sometimes these poses have problems.

## Editing Poses

You can edit and delete your poses through the Web Portal, and even attribute them to other characters (handy if you're emitting from one of your alts).  

For a quick correction, you can also replace your **previous pose** with a corrected one.  Format it like an emit:

`scene/replace <text in the form of an emit>`

To do it silently (for a small typo that isn't worth emitting to everyone in the room) you can do:

`scene/typo <text in the form of an emit>`

You can also just delete your last pose completely.

`scene/undo`

You can also add a missing pose to the scene log (for example - one that happened before the scene log was started).  This will not emit to the other participants:

`scene/addpose <emit>`

## Participants

The log system automatically tracks who participated in the scene.  You can edit this through the web portal.

Sometimes, though, you'll be emitting a character from another character (spoofing them). If you want to just replace all instances of one character with another, you can use the scene spoof command.  For example, if you had emitted Bob from Harry throughout the log, you can switch all of Harry's poses to Bob.  

`scene/spoof <#>=<original char>/<new char>`

> **Tip:** The spoof replacement only applies to past emits, not future ones.  It is best to use it on a completed log.