---
toc: 4 - Writing the Story
summary: Scene logging.
aliases:
- scene log
- scene repose
- repose
- scene share
- scene unshare
- log
- logs
- scene sharing
- scene spoof
- scene edit
- scene replace
- scene undo
- scenes unshared
- unshared
- share
- sharing
---
# Scene Logging

The scenes system captures a RP log automatically for you.  The log will contain poses, skill rolls and combat results.  OOC remarks will be captured while the scene is in progress but deleted once it's over.  Other OOC spam (pages, channels, help text) will not be included.

## Finding Scenes

For many of the scene log commands, you need to know the scene's number.  Some will default to your current scene if you don't give a number.

`scenes/all` - Lists all scenes you have access to.
`scenes/unshared` - Lists all scenes you have access to that haven't been shared yet.

## Viewing the Log

During the scene, you can refer back to the log for a quick catch-up if you joined late or missed poses.  You can also spam yourself with the entire log.  This is most useful for capturing a clean log to your client.

`scene/repose [scene #]` - Quick log catch-up.
`scene/log [scene #]` - Spam yourself with the entire log.

## Editing Poses

You can edit and delete your poses through the Web Portal, and even attribute them to other characters (handy if you're emitting from one of your alts).  

For a quick correction, you can also replace your **previous pose** with a corrected one.  Format it like an emit.

`scene/replace <text in the form of an emit>` - Replaces your last pose.
`scene/typo <text in the form of an emit>` - Silent replace for small typos.
`scene/undo` - Removes your last pose.

You can also add a missing pose to the scene log (for example - one that happened before the scene log was started).  This will not emit to the other participants:

`scene/addpose <emit>`

## Editing Participants

The log system automatically tracks who participated in the scene.   You can add and remove participants.  This is helpful if someone was emitted by an alt but was still ICly present.

`scene/addchar <#>=<char>` - Adds a participant to the scene log.
`scene/removechar <#>=<char>` - Removes a participant from the scene log.

## Sharing the Log

At any point during the scene, you can share the log.  This makes it visible on the game's web portal (see [Website](/help/web_portal)).  Sharing a big event scene while it's still in-progress allows spectators to follow it on the web even if they're not participating.

`scene/share [scene #]` - Shares the log to the web portal.
`scene/unshare [scene #]` - Unshares a log.

## Disabling and Clearing the Log

The log starts automatically when a scene is started.  If for some reason you don't want a scene logged, you can turn disable the log.  This will clear the log and not log anything more in that scene.  You can later re-enable the log to start fresh with a new one.

`scene/disablelog [scene #]` - Note: This also clears any existing poses from the log.
`scene/clearlog [scene #]`
`scene/enablelog [scene #]` - Note: This starts the scene fresh.
