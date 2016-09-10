---
topic: bbs
toc: Communicating
summary: Bulletin boards.
aliases:
- bbs
- bbread
- bbpost
- bbmisc
categories: 
- main
---
The bulletin board system lets you stay posted on game news and events.  There are various **boards** available, each with a different purpose.

For all of the bbs commands, you can specify either the board name or number.  Those familiar with %xh`Myrddin's BBS` from other MUSH systems should find that the commands you're used to (bbread, bbpost, etc.) also work here.

`bbs` - Lists available boards.
`bbs <board>` - Lists posts on the selected board.
`bbs <board>/<post #>` - Reads the selected post.

To quickly read new posts and replies, you can use the bbs/new command.

`bbs/new` - Reads the first unread message.
`bbs/catchup <board>` - Marks all unread messages as read.

On boards that you are allowed to write to, you can post a new message or reply to an existing message.  When replying, you can leave off the post information and it will reply to the last one you read (handy when using bbs/new).

`bbs/post <board>=<subject>/<body>` - Writes a new post.
`bbs/reply <reply>` - Replies to the last post you read.
`bbs/reply <board>/<post #>=<reply>` - Writes a comment as a reply to a post.

You can also edit or delete your own posts.  Currently there is no way to edit or delete replies.

`bbs/edit <board>/<post #>` - Grabs the existing post text into your input 
       buffer (if your client supports it.  See `help edit`.)
`bbs/edit <board>/<post #>=<new text>` - Replaces post text with the new text.
`bbs/delete <board>/<post #>` - Deletes a post
`bbs/move <board>/<post #>=<new board>` - Moves a post from one board to another.