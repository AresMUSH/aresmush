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
- scenes unshared
- unshared
- share
- sharing
---
# Scene Logging
The scenes system captures a RP log automatically for you.  The log will contain poses, skill rolls and combat results.  OOC remarks will be captured while the scene is in progress but deleted once it's over.  Other OOC spam (pages, channels, help text) will not be included.

Do `qr scene` to see a quick reference of all scene commands.

**Tip:** All scene log commands can accept a scene number, or be used on your current scene if you don't specify a number.

`scenes/all` - Lists all scenes you have access to.
`scenes/unshared` - Lists all scenes you have access to that haven't been shared yet.

## Viewing the Log

During the scene, you can refer back to the log for a quick catch-up if you joined late or missed poses.  You can also spam yourself with the entire log.  This is most useful for capturing a clean log to your client.

`scene/repose [scene #]` - Quick log catch-up.
`scene/log [scene #]` - Spam yourself with the entire log.

## Editing Poses

You can edit and delete your poses through the Web Portal's active scenes page. For a quick correction, you can also replace your **previous pose** with a corrected one.  

`scene/replace <text in the form of an emit>`
`scene/typo <text in the form of an emit>` - Silent edit for a small typo that isn't worth emitting to everyone
`scene/undo` - Delete your last pose.
`scene/addpose <emit>` - Add a missing pose to the scene log (for example - one that happened before the scene log was started).  This will not emit to the other participants:

## Editing Participants

The log system automatically tracks who participated in the scene.   You can add and remove participants.

`scene/addchar <#>=<char>`
`scene/removechar <#>=<char>`

## Sharing the Log

At any point during the scene, you can share the log.  This makes it visible on the game's web portal (see [Website](/help/web_portal)).  Sharing a big event scene while it's still in-progress allows spectators to follow it on the web even if they're not participating.

`scene/share [scene #]` - Shares the log to the web portal.
`scene/unshare [scene #]` - Unshares a log.

## Clearing the Log

The log starts automatically when a scene is started.  If for some reason you don't want a scene logged, you can turn logging on and off.  You can also clear all poses from the log.

`scene/startlog [scene #]`
`scene/stoplog [scene #]`
`scene/clearlog [scene #]`
