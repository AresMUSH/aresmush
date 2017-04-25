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

## Pose Order

Pose order tracking is a tool to help you keep track of whose turn it is.  It is **not** intended to be a strict restriction on who's allowed to pose.  Use any order you like in a given scene.

`repose/order` - Shows the pose order of the room.

By default, the system will nudge you when it's your turn to pose, according to the established pose order.  This notification will only happen after the first turn, when repose is on, and when at least three people are in a scene.  You can disable this notification.

`repose/nudge <on or off>`

## Turning Repose On and Off

You can disable the system temporarily to keep a scene private.

`repose/on` or `repose/off` - Turns the system on or off in a room.

## Clearing Poses

Poses and pose order are automatically cleared every hour if there's nobody logged into the room.  If you start a new scene and there are remnants from an old one, you can clear the old poses and pose order.

`repose/clear`
