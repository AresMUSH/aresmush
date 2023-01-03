---
toc: ~admin~ Managing the Game
summary: Managing the roster.
---

> **Permission Required:** These commands require the Admin role or the permission: manage\_roster

Players with the necessary permissions can add and remove people from the roster.  You can optionally include a contact person and notes about the roster character.
# Add a Character to the Roster

DO NOT approve the character first.

`roster/add <name>=<contact>` - Adds someone to the roster.  Contact is optional.
`roster/notes <name>=<summary>` - Adds a short summary of the character.
`roster/played <name>=<yes/no>` - Indicates if the character was previously played.
# Remove a Character from the Roster

`roster/remove <name>` - Removes someone from the roster.
## Roster Applications

When someone tries to claim a roster character, the system will generate a job. You can add comments to the job as normal, but instead of closing it you'll want to use one of the following commands:

`roster/approve <name>=<comment>` - Approves a character. Use the **roster** character name, not the applying character.
`roster/reject <name>=<comment>` - Rejects a character. Use the **roster** character name, not the applying character.

You can also do roster approval/rejections on the web portal through the job screen.
