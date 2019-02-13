---
toc: 4 - Writing the Story
summary: Managing large scenes with places.
aliases:
- tables
---
# Places

The places system allows you to manage large scenes by keeping track of who's where in the room. Places code is designed to **highlight conversations at your place**, not hide conversations at other places.  You will still see everything, but poses from people at your place will automatically have a highlighted title.   This allows you to easily focus on the poses you really need to respond to.

Places in Ares are dynamic.  When you want to start a gathering, you create a place with a title (IE "By the Fireplace" or "Jack's Table").  You can change this if needed (ie Jack poses out or the group at the fire moves to the couch).

`places` - Lists places.
`place/create <title>` - Creates a place.
`place/join <title>` - Joins an existing place.
`place/rename <old title>=<new title>` - Renames a place
`place/leave` - Leaves your place.
`place/delete <title>` - Removes a place from the room.
`place/emit <title>=<emit>` - Emits from a place you're not at.
