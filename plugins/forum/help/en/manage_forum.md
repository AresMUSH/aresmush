---
toc: ~admin~ Managing the Game
summary: Managing the forums.
aliases:
- bbwiz
- forum manage
- bbs manage
---
# Managing the Forum

> **Permission Required:** These commands require the Admin role or the permission: manage\_forum

Those with admin privileges are create and manage categories.

## Creating and Deleting Categories

Forum admins can create and delete categories.  Each category must be uniquely identified by name and can be given a description with the category's purpose.  You can change a category's name at any time.

`forum/createcat <name>`
`forum/describe <category>=<description>`
`forum/rename <category>=<new name>`
`forum/deletecat <category>`

## Changing Board Order

You can change the order that the categories are displayed in by assigning each an order number.

`forum/order <category>=<order #>`

## Access Roles

Access to forums is done by role.  You can define a role in the [Roles System](/help/roles) and then give that role read and/or write permissions to a forum category.  

Posting and replying to a forum requires 'write' permissions.

`forum/readroles <category>=<comma-separated roles that can read it, or 'everyone'>`
`forum/writeroles <category>=<comma-separated roles that can write to it, or 'everyone'>`

## Archiving a Board

You can archive the messages from a forum category for offline storage.  The default format is suitable for a wiki page.

`forum/archive <category>` - Prints out messages so you can log them to a file.

## Editing, Moving and Deleting Posts

You can edit and delete other peoples' posts as well as their own.  You can also mass delete posts to clean up categories.

> **Tip:** It is recommended that you archive a category before doing a mass delete, as there is no 'undo'.  Deleted messages are permanently gone.

`forum/delete <category>/<#>-<#>`