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

## Managing Categories

Forum admins can create and delete categories on the web portal.  Go to [Admin -> Setup -> Setup Forum](/forum-manage). Category properties include:

* Name - A unique name for the category. You can change the name at any time.
* Description - Optional description for the category's purpose.
* Order - The order that categories are displayed on the forum index. If there are multiple forums with the same order number, they will be sorted by name.
* Read Roles - People with these [roles](/help/roles) are allowed to see the forum. You can use 'everyone' to let everybody read.
* Write Roles - People with these [roles](/help/roles) are allowed to post and reply to the forum. To prevent abuse, it is advised that you minimally lock each forum to the 'approved' role.

`forum/createcat <name>`
`forum/describe <category>=<description>`
`forum/rename <category>=<new name>`
`forum/deletecat <category>`
`forum/order <category>=<order #>`
`forum/readroles <category>=<comma-separated roles that can read it, or 'everyone'>`
`forum/writeroles <category>=<comma-separated roles that can write to it, or 'everyone'>`

## Editing, Moving and Deleting Posts

You can edit and delete other peoples' posts as well as their own.  You can also mass delete posts to clean up categories.

> **Tip:** It is recommended that you archive a category before doing a mass delete, as there is no 'undo'.  Deleted messages are permanently gone.

`forum/delete <category>/<#>-<#>`

## Pinning Posts

Posts can be pinned (or made sticky) so they show up first regardless of when they were posted.

`forum/pin <category>/<#>=<on or off>`
  
## Archiving a Board

You can archive the messages from a forum category for offline storage.  The default format is suitable for a wiki page.

`forum/archive <category>` - Prints out messages so you can log them to a file.
