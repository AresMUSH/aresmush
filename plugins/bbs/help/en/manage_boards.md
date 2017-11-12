---
toc: ~admin~ Managing the Game
summary: Managing bulletin boards.
aliases:
- bbwiz
---
# BBS - Managing Boards

> **Permission Required:** These commands require the Admin role or the permission: manage\_bbs

Those with board privileges are create and manage boards.

## Creating and Deleting Boards

Board admins can create and delete boards.  Each board must be uniquely identified by name and can be given a description with the board's purpose.  You can change a board's name at any time.

`bbs/createboard <name>`
`bbs/describe <board>=<description>`
`bbs/rename <board>=<new name>`
`bbs/deleteboard <board>`

## Changing Board Order

You can change the order that the boards are displayed in by assigning each an order number.

`bbs/order <board>=<order #>`

## Access Roles

Access to bulletin boards is done by role.  You can define a role in the [Roles System](/help/roles) and then give that role read and/or write permissions to a board.  

Posting and replying to a board requires 'write' permissions.

`bbs/readroles <board>=<roles that can read it, or 'everyone'>`
`bbs/writeroles <board>=<roles that can write to it, or 'everyone'>`
> **Permission Required:** These commands require the Admin role or the permission: manage\_bbs

## Archiving a Board

You can archive the messages from a bulletin board for offline storage.  The default format is suitable for a wiki page.

`bbs/archive <board>` - Prints out messages so you can log them to a file.

## Editing, Moving and Deleting Posts

You can edit and delete other peoples' posts as well as their own.  You can also mass delete posts to clean up boards.

> **Tip:** It is recommended that you archive a board before doing a mass delete, as there is no 'undo'.  Deleted messages are permanently gone.

`bbs/delete <board>/<#>-<#>`