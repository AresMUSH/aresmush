---
toc: ~admin~ Managing the Game
summary: Managing the forums.
aliases:
- bbwiz
- forum manage
- bbs manage
---
# Managing the Forum

> **These commands require the Admin role or the permission: manage\_forum**

## Creating and Deleting Categories

`forum/createcat <name>`

`forum/describe <category>=<description>`
`forum/rename <category>=<new name>` - Renames a forum.  You can use this to change capitalization on the name as well as changing the name itself.
`forum/deletecat <category>`
`forum/order <category>=<order #>`

## Access Roles

Access to forums is done by [role](/help/roles). You can give a role read and/or write permissions to a forum category. Posting and replying to a forum requires 'write' permissions.

`forum/readroles <category>=<comma-separated roles that can read it, or 'everyone'>`
`forum/writeroles <category>=<comma-separated roles that can write to it, or 'everyone'>`

## Archiving a Board

`forum/archive <category>` - Prints out messages so you can log them to a file.

## Editing, Moving and Deleting Posts

You can edit and delete other peoples' posts as well as their own.  You can also mass delete posts to clean up categories.

**Tip:** It is recommended that you archive a category before doing a mass delete, as there is no 'undo'.  Deleted messages are permanently gone.

`forum/delete <category>/<#>-<#>`

## Pinning Posts

Posts can be pinned (or made sticky) so they show up first regardless of when they were posted.

`forum/pin <category>/<#>=<on or off>`
