---
topic: database
toc: Code Management
summary: Examining and manipulating the database.
categories:
- admin
aliases:
- examine
- rename
- name
- destroy
- nuke
- reload
- find
- search
---
There are several commands that let you view and manipulate objects in the database.  For these commands, you can specify either an object name or object database ID.  You do not need to be in the same room as the object unless there are multiple objects with the same name.

`rename <name or database ID>=<new name>` - Renames an object.
`examine <name or database ID>` - Examines an object. 
`destroy <name or database ID>` - Deletes an item from the database.  
        %xrTHIS CANNOT BE UNDONE%xn.

The `find` command lists objects.  You can search by object type:  Room, Character, Exit.  For instance to find all rooms you would use:   find Room. 

`find <object type>[=<name, optional>]`

There is no equivalent to the generic 'set' command you might be familiar with from other MUSHes.  Instead, individual commands provide ways to update data.  

**IMPORTANT NOTE:** Since Ares uses a conventional database back-end, it is possible to modify data directly in the database.  But when you do this, you must issue the `reload` command so that the memory copies of the data objects are updated.
