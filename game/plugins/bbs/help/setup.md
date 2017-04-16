---
toc: Bulletin Boards
summary: Setting up bulletin boards.
order: 99
aliases:
- bbwiz
---
# BBS - Setting Up Boards

> **Permission Required:** These commands require the permission: manage\_bbs

Those with board privileges are create and setup boards.

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