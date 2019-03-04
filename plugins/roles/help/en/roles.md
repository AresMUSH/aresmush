---
toc: ~admin~ Managing the Game
summary: Managing roles.
---
# Roles

> **These commands require the Admin role.**

Game admins can manage what roles are available in the game and what people have those roles.  Roles in turn grant permissions.  See the [roles tutorial](http://aresmush.com/tutorials/manage/roles.html) for more details about how to use roles.

**Tip:**  You can't assign individual permissions to characters.  Permissions are assigned to roles, which in turn are assigned to characters.

### The Everyone Role

The 'Everyone' role is automatically assigned to all character objects.  You can assign permissions to this role too if you want everybody to be able to use a command that is normally restricted in AresMUSH.

## Creating & Roles

`role/create <name>`
`role/delete <name>`

`roles` - Sees your roles.
`roles <name>` - Show the roles assigned to a character.
`role/add <name>=<role>` - Add a role to a character.
`role/remove <name>=<role>` - Removes a role from a character.

## Assigning Permissions to Roles

`role/addpermission <role>=<permission>` - Adds a permission to a role.
`role/removepermission <role>=<permission>` - Removes a permission from a role.

See a [list of permissions](aresmush.com/tutorials/manage/roles#default-permissions).
