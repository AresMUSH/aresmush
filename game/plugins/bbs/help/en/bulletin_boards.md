---
toc: Communicating
summary: Reading the bulletin boards.
aliases:
- bbread
- bbpost
- bbmisc
- bbreply
- bbedit
- board
- bbs
---
# Bulletin Boards

Inspired by the widely-loved [Myrrdin’s Bulletin Board System](http://www.firstmagic.com/~merlin/mushcode/mc.bb.html), the Ares BBS provides MU-wide discussion forums.

> **Tip:** For all of the bbs commands, you can specify either the board name or number.  Those familiar with Myrddin's BBS should find that the commands you're used to (bbread, bbpost, etc.) also work here.

    +==~~~~~====~~~~====~~~~====~~~~=====~~~~=====~~~~====~~~~====~~~~====~~~~~==+
      #       Name                        Description                         R/W
    ------------------------------------------------------------------------------
      1       Announcements               Important announcements.            rw   
      2       Requests                    Questions, bugs or suggestions.     rw   
      3       Cookie Awards                                                   rw   
    +==~~~~~====~~~~====~~~~====~~~~=====~~~~=====~~~~====~~~~====~~~~====~~~~~==+

The 'rw' on the end tells you whether you can read and/or write to the board.

## Reading Boards

### Listing Boards

The game has a variety of bulletin boards, each with a different purpose.  You can see the list of boards and their descriptions.

To read a board, you need to use the `bbs` command with the board name or number.  To read the announcements board you could use either `bbs 1` or `bbs announcements`.  You can also use part of the name as long as it's enough to distinguish which board you're after:  `bbs announce`.  This will show you the board's summary and a list of posts.

`bbs` - Lists available boards.
`bbs <board>` - Lists posts on the selected board.

## Reading Posts

To read a specific post, you use the board name/number and post number.  To read the first message on the Announcements board, you could use `bbs 1/1` or `bbs announce/1`.

`bbs <board>/<post #>` - Reads the selected post.

### Reading All New Posts

The game will tell you when someone has posted a new message to the BBS.  You will also receive a notification of unread posts when you log in.  You can use the `bbs/new` command to read the first available new post.  You can keep using that command over and over until all the posts are read.

If you've already read the post on another character, or you're just not interested in posts to a particular board, you can use the catchup command to mark all posts on a board as read.

> Tip:  If you link your characters to a [Player Handle](/help/handles), the game will automatically mark a post as read on all your characters when you read it on one.

`bbs/new` - Reads the first unread message on any board.
`bbs/catchup <board>` - Marks all unread messages as read.

## Posting to a Board

To post a message to a board, you use the `bbs/post` command with the board name/number, a title and a message.

`bbs/post <board>=<title>/<body>` - Writes a new post.

### Editing a Post

If you need to edit a post after it's been posted, you can use the edit command with the board name/number and the post number.  This will replace the post title and message with the new text.

If your client supports the [Edit Feature](/help/edit), you can use the edit command with just the board and post number to grab the post text into your client's input buffer: `bbs/edit 1/6`

`bbs/edit <board>/<post #>=<new text>` - Replaces post text with the new text.
`bbs/edit <board>/<post #>` - Grabs the existing post text into your input buffer.

### Moving a Post

You can move a post from one board to another using the move command.  Just specify the original board and post number, and the new board name/number.

`bbs/move <board>/<post #>=<new board>` - Moves a post from one board to another.

### Deleting a Post

To delete a post completely, including all of its replies, use the delete command with the board name/number and post number.

`bbs/delete <board>/<post #>` - Deletes a post

## Replying to Posts

The BBS system lets you carry on a thread of conversation by replying to posts.  Replies show up underneath the original post when you read it.

To reply to a message, use the board name/number, post number and your response: `bbs/reply 3/4=My reply.`

If you've just read a post, you can reply to it without specifying the name and number.  Just give a message and it will reply to the last post you've read: `bbs/reply My reply.`

`bbs/reply <board name or number>/<post number>=<reply>` - Replies to a bbs post.
`bbs/reply <reply>` - Replies to the last post you read.

### Deleting Replies

You cannot edit a reply once it's been posted, but you can delete it and try again.  Use the deletereply command with the board, post and reply number:  `bbs/deletereply 3/4=1`

Board administrators with the **can\_manage\_board** permission are able to delete other people's replies.

`bbs/deletereply <board name or number>/<post number>=<reply number>` - Deletes a bbs reply.