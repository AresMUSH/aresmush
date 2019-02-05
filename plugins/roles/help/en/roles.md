---
toc: ~admin~ Managing the Game
summary: Managing roles.
---
# Roles

> **Permission Required:** These commands require the Admin role.

Game admins can manage what roles are available in the game and what people have those roles.  Roles in turn grant permissions.  See the [roles tutorial](http://aresmush.com/tutorials/manage/roles) for more details about how to use roles.

> **Tip:**  You can't assign individual permissions to characters.  Permissions are assigned to roles, which in turn are assigned to characters.

### The Everyone Role

There is a special role called 'Everyone' that is automatically assigned to, well, everyone.  You can assign permissions to this role too if you want everybody to be able to use a command that is normally restricted in AresMUSH.

For example:  Teleporting around is normally restricted to the 'teleport' permission.  If you give the Everyone role that permission, then everybody will be able to teleport.

## Creating Roles

You can create and delete roles.

`role/create <name>`
`role/delete <name>`

## Assigning Roles to Characters

You can assign roles to people.

`roles` - Sees your roles.
`roles <name>` - Show the roles assigned to a character.
`role/add <name>=<role>` - Add a role to a character.
`role/remove <name>=<role>` - Removes a role from a character.

## Assigning Permissions to Roles

Once a role exists, you can add and remove permissions to it.

`role/addpermission <role>=<permission>` - Adds a permission to a role.
`role/removepermission <role>=<permission>` - Removes a permission from a role.