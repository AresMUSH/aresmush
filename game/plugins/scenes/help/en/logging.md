---
toc: Scenes
summary: Scene logging.
aliases:
- scene log
- scene repose
- repose
- scene share
- scene unshare
- log
- scene sharing
- scene spoof
- scene edit
- scene replace
- scene undo
---
# Scene Logging

The scenes system can capture a RP log automatically for you.  The log will contain poses, skill rolls and combat results but not OOC spam.

> **Tip:** All scene log commands can accept a scene number, or be used on your current scene if you don't specify a number.

## Viewing the Log

During the scene, you can refer back to the log for a quick catch-up if you joined late or missed poses.  You can also spam yourself with the entire log.  This is most useful for capturing a clean log to your client.

`scene/repose [scene #]` - Quick log catch-up.
`scene/log [scene #]` - Spam yourself with the entire log.

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

## Editing Participants

The log system automatically tracks who participated in the scene.  You can edit this through the web portal.

Sometimes, though, you'll be emitting a character from another character (spoofing them). If you want to just replace all instances of one character with another, you can use the scene spoof command.  For example, if you had emitted Bob from Harry throughout the log, you can switch all of Harry's poses to Bob.  

`scene/spoof <#>=<original char>/<new char>`

> **Tip:** The spoof replacement only applies to past emits, not future ones.  It is best to use it on a completed log.

## Sharing the Log

At any point during the scene, you can share the log.  This makes it visible on the game's web portal (see [Website](/help/web_portal)).  Sharing a big event scene while it's still in-progress allows spectators to follow it on the web even if they're not participating.

`scene/share [scene #]` - Shares the log to the web portal.
`scene/unshare [scene #]` - Unshares a log.

## Posting the Log

If your game uses a wiki, the wiki system will let you either automatically post the log to the wiki (if enabled), or to get the wiki text to copy paste.  See [Wiki](/help/wiki) for more information.

## Clearing the Log

The log starts automatically when a scene is started.  If for some reason you don't want a scene logged, you can turn logging on and off.  You can also clear all poses from the log.

`scene/startlog [scene #]`
`scene/stoplog [scene #]`
`scene/clearlog [scene #]`
