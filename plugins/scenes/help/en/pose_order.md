---
toc: Scenes
summary: Keeping track of pose order.
aliases:
- pose_order
- pose_nudge
- pose_skip
- pose_drop
- pose_ordertype
---
# Pose Order

Pose order tracking is a tool to help you keep track of whose turn it is.  It is **not** intended to be a strict restriction on who's allowed to pose.  Use any order you like in a given scene.

`pose/order` - Shows the pose order of the room.

By default, the system will nudge you when it's your turn to pose, according to the established pose order.  This notification will only happen after the first turn, when repose is on.  You can disable this notification or temporarily gag it until your next login.

`pose/nudge <on, off or gag>`

If someone's idle or passing, you can skip their turn.  As soon as they pose again, they'll jump in at their new spot.  You can also drop them from the scene completely.

`pose/skip <name>`
`pose/drop <name>`

For large scenes, you can switch from regular order to 3-pose order, where people will be nudged after three other people have posed.

`pose/ordertype <normal, 3-per>`

