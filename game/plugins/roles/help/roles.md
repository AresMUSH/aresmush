---
topic: roles
toc: Roles
summary: Assigning permissions.
categories:
- admin
aliases:
- role
- permission
- power
plugin: roles
---
Some commands are restricted so that only characters with certain roles can access them.  For example, many games will lock the building commands so that only authorized builders can create new rooms and exits.

Roles are defined in the configuration files.  You can assign and remove roles from individual characters using the role command.  This, of course, requires its own permissions.

`roles` - Show the available roles and those assigned to you.
`roles <name>` - Show the roles assigned to a character.
`role/add <name>=<role>` - Add a role to a character.
`role/remove <name>=<role>` - Removes a role from a character.
