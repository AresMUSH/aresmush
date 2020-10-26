---
toc: ~admin~ Managing the Game
summary: Examining and manipulating the database.
aliases:
- examine
- rename
- name
- destroy
- find
- search
---
# Managing the Database

> **Permission Required:** These commands require the Admin role or the manage\_game permission.  Modifying rooms can also be done with the build permission.

There are several commands that let you view and manipulate objects in the database.  For these commands, you can specify either an object name or object database ID.  You do not need to be in the same room as the object unless there are multiple objects with the same name.

`name <name or database ID>=<new name>` - Renames an object.
`examine <name or database ID>[/<attribute>]` - Examines an object, optionally specifying an attribute name.
`destroy <name or database ID>` - Deletes an item from the database.  
        %xrTHIS CANNOT BE UNDONE%xn.

The `find` command lists objects.  You can search by object type:  Room, Character, Exit.  For instance to find all rooms you would use:   find Room. 

`find <object type>[=<name, optional>]`

There is no equivalent to the generic 'set' command you might be familiar with from other MUSHes.  Instead, individual commands provide ways to update data.

## Database Backups

Ares contains an automated backup system. By default, backups will be stored locally in the aresmush/backups folder. You can also set up external backups.  See [Managing Backups](https://aresmush.com/tutorials/manage/backups.html) for details.

`backup` - Triggers an immediate backup.