---
toc: ~admin~ Managing Game
summary: Managing the roster.
---
# Managing the Roster

> **Permission Required:** These commands require the Admin role or the permission: manage\_roster

Players with the necessary permissions can add and remove people from the roster.

`roster/add <name>=<contact>` - Adds someone to the roster.  Contact is optional.
`roster/remove <name>` - Removes someone from the roster.

You can optionally include a contact person and notes about the roster character.

`roster/contact <name>=<contact>` - Updates contact info on roster.  
`roster/notes <name>=<notes>` - Adds roster notes.

## Restricted Characters

Roster characters normally are just claimed with no fanfare using the `roster/claim` command.  For special characters, you may want to require people to talk to the contact person and/or submit an application.  Characters marked as 'restricted' can't be claimed via a simple command.

`roster/restrict <name>=<on or off>` - Restricts claims.

When someone wants to claim a restricted character, staff will have to manually remove them from the roster, reset their password, and send the password to the new player somehow.