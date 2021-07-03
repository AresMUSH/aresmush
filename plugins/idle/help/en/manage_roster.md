---
toc: ~admin~ Managing the Game
summary: Managing the roster.
---
# Managing the Roster

> **Permission Required:** These commands require the Admin role or the permission: manage\_roster

Players with the necessary permissions can add and remove people from the roster.  You can optionally include a contact person and notes about the roster character.

`roster/add <name>=<contact>` - Adds someone to the roster.  Contact is optional.
`roster/remove <name>` - Removes someone from the roster.
`roster/notes <name>=<summary>` - Adds a short summary of the character.
`roster/played <name>=<yes/no>` - Indicates if the character was previously played.

## Roster Applications

Roster characters are normally claimed with no fanfare using the `roster/claim` command.  Characters marked as 'restricted' require an application first.

`roster/restrict <name>=<on or off>` - Restricts claims.

> Note: There is also an option in the game configuration to require an app for all roster chars, so you don't have to set it each time.

When someone tries to claim a restricted character, the system will generate a job. You can add comments to the job as normal, but instead of closing it you'll want to use one of the following commands:

`roster/approve <name>=<comment>` - Approves a character. Use the **roster** character name, not the applying character.
`roster/reject <name>=<comment>` - Approves a character. Use the **roster** character name, not the applying character.

Approving a character will reset their password and add it as a comment to the job. Rejecting a roster app will free up the roster char so others can claim them (or the original player can re-apply). You can also do roster approval/rejections on the web portal through the job screen.

> Note: If the player submits the roster app from another character on the game (an alt or [player bit](/help/playerbit)), they will see the response and password in their request. If they submit from a guest, they should have included an email and you can send the password there.