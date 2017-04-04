---
topic: bbs edit
summary: Editing BBS messages.
toc: Bbs
aliases:
categories:
- main
plugin: bbs
---
You can edit or delete your own posts.  

`bbs/edit <board>/<post #>` - Grabs the existing post text into your input 
       buffer (if your client supports it.  See `help edit`.)
`bbs/edit <board>/<post #>=<new text>` - Replaces post text with the new text.
`bbs/delete <board>/<post #>` - Deletes a post

You can also move a post around.

`bbs/move <board>/<post #>=<new board>` - Moves a post from one board to another.

You can't edit replies, but you can delete them.

`bbs/deletereply <board>/<post #>=<reply #>` - Deletes a reply.