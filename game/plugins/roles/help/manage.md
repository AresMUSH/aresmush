---
toc: ~admin~ Managing Game
summary: Managing roles.
aliases:
- adminnote
---
# Managing Roles

> **Permission Required:** These commands require the Admin role.

Game admins can manage what roles are available in the game and what people have those roles.

## Roles vs Permissions

There are two levels to the Roles system:  roles and permissions.

Roles are assigned to characters.  You could have a 'builder' role or a 'pilot' role.  Some things - like channels or bulletin boards - can be locked so that only people with certain roles can use them.

Permissions are assigned to roles, and allow you to further refine what people with a given role can do.  

### Using Permissions

> **Tip:** Characters with the Admin role have all permissions automatically.  If you don't want to fuss with multiple levels of staff, you don't need to worry about permissions.

Each plugin defines its own permissions and what commands require them.  The help files tell you what permissions are needed.  For example - at the top of this file it tells you that the manage_roles permissions is needed to do 

For example:  You might create a 'builder' role and assign it the 'build' and 'teleport' permissions.  Then all builders would be able to build rooms/exits and teleport around without having access to all other admin commands.  You might also create an 'app_staff' role that had application permissions but not building permissions.  It's completely flexible.

### The Everyone Role

There is a special role called 'Everyone' that is automatically assigned to, well, everyone.  You can assign permissions to this role too if you want everybody to be able to use a command that is normally restricted in AresMUSH.

For example:  Teleporting around is normally restricted to the 'teleport' permission.  If you give the Everyone role that permission, then everybody will be able to teleport.

## Creating Roles

You can create and delete roles.

`role/create <name>`
`role/delete <name>`

## Assigning Roles to Characters

You can assign roles to people.

`roles <name>` - Show the roles assigned to a character.
`role/add <name>=<role>` - Add a role to a character.
`role/remove <name>=<role>` - Removes a role from a character.

## Assigning Permissions to Roles



## Admin Notes

The `admin` command lists all game admins.  It automatically finds people based on whether they have one of the roles you have defined as an admin role in your game config.  

You can also set a note to appear next to your name on the admins list, describing your role.

`adminnote <note>` - Sets your note.
