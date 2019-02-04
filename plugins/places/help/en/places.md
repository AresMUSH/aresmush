---
toc: 4 - Writing the Story
summary: Managing large scenes with places.
aliases:
- tables
---
# Places

The places system allows you to manage large scenes by keeping track of who's where in the room.

Places in Ares work differently than what you might be used to from other games.  For one, they're dynamic.  When you want to start a gathering, you just create a place with a title.  This title could be anything from "By the Fireplace" to "Jack's Table".     You can change this if need be (like if Jack poses out or the group at the fire moves to the couch).

Once the place is created, people can join it.   Places code is designed to **highlight conversations at your place**, not hide conversations at other places.  You will still see everything, but poses from people at your place will automatically have a highlighted title.   This allows you to easily focus on the poses you really need to respond to, without requiring special pose commands, double poses, weird "..." mutters or other hallmarks of traditional table talk code.


`places` - Lists places.
`place/create <title>` - Creates a place.
`place/join <title>` - Joins an existing place.
`place/rename <old title>=<new title>` - Renames a place
`place/leave` - Leaves your place.
`place/delete <title>` - Removes a place from the room.
`place/emit <title>=<emit>` - Emits from a place you're not at.