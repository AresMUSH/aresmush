---
toc: Scenes
summary: Scene logging.
aliases:
- scene log
- repose
- scene share
- scene unshare
---
# Scene Logging

The scenes system can capture a RP log automatically for you.  The log will contain poses, skill rolls and combat results but not OOC spam.

> **Tip:** All scene log commands can accept a scene number, or be used on your current scene if you don't specify a number.

## Viewing the Log

During the scene, you can refer back to the log for a quick catch-up if you joined late or missed poses.  You can also spam yourself with the entire log.  This is most useful for capturing a clean log to your client.

`log [scene #]` - Quick log catch-up.
`log/all [scene #]` - Spam yourself with the entire log.

## Sharing the Log

At any point during the scene, you can share the log.  This makes it visible on the game's web portal (see [Website](/help/website)).  Sharing a big event scene while it's still in-progress allows spectators to follow it on the web even if they're not participating.

`log/share [scene #]` - Shares the log to the web portal.
`log/unshare [scene #]` - Unshares a log.

## Posting the Log

If your game uses a wiki, the wiki system will let you either automatically post the log to the wiki (if enabled), or to get the wiki text to copy paste.  See [Wiki](/help/wiki) for more information.

## Clearing the Log

If for some reason you don't want a scene logged at all, you can turn logging on and off.  You can also clear all poses from the log.

`log/on [scene #]`
`log/off [scene #]`
`log/clear [scene #]`