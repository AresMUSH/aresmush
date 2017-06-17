---
summary: Reading BBS messages.
toc: Bulletin Boards
---
# BBS - Reading Boards

The game has a variety of bulletin boards, each with a different purpose.  You can see the list of boards and their descriptions.

`bbs` - Lists available boards.

    +==~~~~~====~~~~====~~~~====~~~~=====~~~~=====~~~~====~~~~====~~~~====~~~~~==+
      #       Name                        Description                         R/W
    ------------------------------------------------------------------------------
      1       Announcements               Important announcements.            rw   
      2       Requests                    Questions, bugs or suggestions.     rw   
      3       Cookie Awards                                                   rw   
    +==~~~~~====~~~~====~~~~====~~~~=====~~~~=====~~~~====~~~~====~~~~====~~~~~==+

The 'rw' on the end tells you whether you can read and/or write to the board.

## Viewing the Board Summary

To read a board, you need to use the `bbs` command with the board name or number.  To read the announcements board you could use either `bbs 1` or `bbs announcements`.  You can also use part of the name as long as it's enough to distinguish which board you're after:  `bbs announce`.  This will show you the board's summary and a list of posts.

`bbs <board>` - Lists posts on the selected board.

## Reading a Post

To read a specific post, you use the board name/number and post number.  To read the first message on the Announcements board, you could use `bbs 1/1` or `bbs announce/1`.

`bbs <board>/<post #>` - Reads the selected post.

## Reading New Posts

The game will tell you when someone has posted a new message to the BBS.  You will also receive a notification of unread posts when you log in.  You can use the `bbs/new` command to read the first available new post.  You can keep using that command over and over until all the posts are read.

If you've already read the post on another character, or you're just not interested in posts to a particular board, you can use the catchup command to mark all posts on a board as read.

> Tip:  If you link your characters to a [Player Handle](/help/handles), the game will automatically mark a post as read on all your characters when you read it on one.

`bbs/new` - Reads the first unread message on any board.
`bbs/catchup <board>` - Marks all unread messages as read.
