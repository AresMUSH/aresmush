---
topic: details
toc: Descriptions
summary: Expand your description with separate details.
categories:
- main
aliases:
- detail
---
Details can be used to keep more detailed views separate from the main description.  For example, if your character has a ring, you might create a really detailed description of that ring and put it in a "Ring" detail.  You could also do this for signs, notes, and other landmarks in rooms.  Details take the place of desc-placeholder objects that one might find in other MUSH servers.

`detail/set <name>/<detail title>=<description>`
`detail/delete <name>/<detail title>`
`detail/edit <name>/<detail title>` - Grabs the existing detail into your input 
       buffer (if your client supports it.  See `help edit`.)
 You view details using the regular look command:

`look <name>/<detail title>` - Looks at a detail on something.
