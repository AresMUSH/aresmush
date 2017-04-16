---
toc: Bulletin Boards
summary: Bulletin boards.
aliases:
- bbread
- bbpost
- bbmisc
---
# Bulletin Board

Inspired by the widely-loved [Myrrdin’s Bulletin Board System](http://www.firstmagic.com/~merlin/mushcode/mc.bb.html), the Ares BBS provides MU-wide discussion forums.

## Command Quick Reference

> **Tip:** For all of the bbs commands, you can specify either the board name or number.  Those familiar with Myrddin's BBS should find that the commands you're used to (bbread, bbpost, etc.) also work here.

`bbs` - Lists available boards.
`bbs <board>` - Lists posts on the selected board.
`bbs <board>/<post #>` - Reads the selected post.

`bbs/new` - Reads the first unread message.
`bbs/catchup <board>` - Marks all unread messages as read.

`bbs/post <board>=<title>/<body>` - Writes a new post.

`bbs/edit <board>/<post #>` - Grabs the existing post text into your input buffer.
`bbs/edit <board>/<post #>=<new text>` - Replaces post text with the new text.
`bbs/delete <board>/<post #>` - Deletes a post
`bbs/move <board>/<post #>=<new board>` - Moves a post from one board to another.

`bbs/reply <reply>` - Replies to the last post you read.
`bbs/reply <board>/<post #>=<reply>` - Writes a comment as a reply to a post.
`bbs/deletereply <board>/<post #>=<reply #>` - Deletes a reply.

## Topics

[Reading Boards](/help/bbs/reading)
[Making Posts](/help/bbs/posting)
[Replying to Posts](/help/bbs/replies)
[Setting Up Boards](/help/bbs/setup)
[Managing Boards](/help/bbs/manage)
