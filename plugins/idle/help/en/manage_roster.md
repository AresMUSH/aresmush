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

## Restricted Characters

Roster characters normally are just claimed with no fanfare using the `roster/claim` command.  For special characters, you may want to require people to talk to the contact person and/or submit an application.  Characters marked as 'restricted' can't be claimed via a simple command.

`roster/restrict <name>=<on or off>` - Restricts claims.

When someone wants to claim a restricted character, staff will have to manually remove them from the roster, reset their password, and send the password to the new player somehow.