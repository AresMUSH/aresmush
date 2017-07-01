---
toc: Scenes
summary: Pose order and repose.
aliases:
- po
---
# Repose

The repose system keeps track of poses so you can catch up on what you've missed.  

`repose` - View catchup poses.

## Logging

By default, the repose system will only show you the last few poses for a quick catch-up.  However, you can also use it as a scene logger to capture only the poses and none of the OOC junk.  

`repose/all` - Sees all poses from the scene.

> **Tip:** To ensure you get only the poses for your scene, do `repose/clear` at the beginning of your scene to clear out any old poses.


## Turning Repose On and Off

You can disable the system temporarily to keep a scene private.

`repose/on` or `repose/off` - Turns the system on or off in a room.

## Clearing Poses

Poses and pose order are automatically cleared every hour if there's nobody logged into the room.  If you start a new scene and there are remnants from an old one, you can clear the old poses and pose order.

`repose/clear`
