---
toc: Scenes
summary: Pose order.
---
# Pose Order

Pose order tracking is a tool to help you keep track of whose turn it is.  It is **not** intended to be a strict restriction on who's allowed to pose.  Use any order you like in a given scene.

`pose/order` - Shows the pose order of the room.

By default, the system will nudge you when it's your turn to pose, according to the established pose order.  This notification will only happen after the first turn, when repose is on, and when at least three people are in a scene.  You can disable this notification or temporarily gag it until your next login.

`pose/nudge <on, off or gag>`

If someone idles out but hasn't left the room, you can remove them from the pose order.  As soon as they pose again, they'll jump in at their new spot.

`pose/drop <name>`