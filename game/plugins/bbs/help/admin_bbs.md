---
topic: bbs
toc: Game Management
summary: Managing bulletin boards.
aliases:
- bbs
- bbread
- bbpost
- bbwiz
categories:
- admin
plugin: bbs
---
Those with board admin privileges are able to edit and delete other peoples' posts as well as their own.  You can also mass delete posts to clean up boards, and perhaps archive them to wikidot format first.

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