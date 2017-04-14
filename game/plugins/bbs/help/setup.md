---
toc: Bulletin Boards
summary: Managing bulletin boards.
aliases:
- bbwiz
---
# BBS - Setting Up Boards

> **Permissions Required:** These commands require the permission: can\_manage\_bbs

Those with board privileges are able to edit and delete other peoples' posts as well as their own.  You can also mass delete posts to clean up boards, and perhaps archive them to wikidot format first.

`bbs/delete <board>/<#>-<#>`
`bbs/archive <board>` - Prints out messages so you can log them to a file.

Board admins can also create and delete boards:

`bbs/createboard <name>`
`bbs/deleteboard <board>`

And set their descriptions as well as who can read or write (post) to them:

`bbs/describe <board>=<description>`
`bbs/readroles <board>=<roles that can read it, or 'everyone'>`
`bbs/writeroles <board>=<roles that can write to it, or 'everyone'>`

You can also change the order that the boards are displayed in by assigning each an order number:

`bbs/order <board>=<order #>`
`bbs/rename <board>=<new name>`



Some other miscellaneous features:

* Board permissions tie into the Roles plugin, allowing you to define which roles can read and write to each board.
* You can reply to board posts.  Replies are shown inline with the original post.
* Admins can archive bbs posts to a wikidot format for offline archiving.