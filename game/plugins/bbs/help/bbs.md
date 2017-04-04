---
topic: bbs
toc: Bbs
order: 1
summary: Bulletin boards.
aliases:
- bbs
- bbread
- bbpost
- bbmisc
categories:
- main
plugin: bbs
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

See also `help bbs edit` for info on editing posts.

