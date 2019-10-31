---
toc: 4 - Writing the Story
summary: Managing large scenes with places.
aliases:
- tables
---
# Places

The places system allows you to manage large scenes by keeping track of who's where in the room.  Places are dynamic, so you can make one for anything from "Jack's Table" to "By the Fireplace".  Once a place is created, people can join them to show where they are.

`places` - Lists places.
`place/create <title>` - Creates a place.
`place/join <title>` - Joins an existing place.
`place/rename <old title>=<new title>` - Renames a place
`place/leave` - Leaves your place.
`place/delete <title>` - Removes a place from the room.
`place/emit <title>=<emit>` - Emits from a place you're not in. (useful for storytellers)
  
> **Tip:** Places code is designed to **highlight conversations at your place**, not hide conversations at other places.  You will still see all poses, but ones from people in your place will be highlighted.