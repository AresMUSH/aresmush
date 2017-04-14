---
summary: Reading BBS messages.
toc: Bulletin Boards
aliases:
---
# BBS - Reading Boards

The game has a variety of bulletin boards, each with a different purpose.  You can see a list of boards using the `bbs` command.

    +==~~~~~====~~~~====~~~~====~~~~=====~~~~=====~~~~====~~~~====~~~~====~~~~~==+
      #       Name                        Description                         R/W
    ------------------------------------------------------------------------------
      1       Announcements               Important announcements.            rw   
      2       Requests                    Questions, bugs or suggestions.     rw   
      3       Cookie Awards                                                   rw   
    +==~~~~~====~~~~====~~~~====~~~~=====~~~~=====~~~~====~~~~====~~~~====~~~~~==+

The 'rw' on the end tells you whether you can read and/or write to the board.

## Viewing the Board Summary

To read a board, you need to use the `bbs/read` command with the board name or number.  To read the announcements board you could use either `bbs/read 1` or `bbs/read announcements`.  You can also use part of the name as long as it's enough to distinguish which board you're after:  `bbs/read announce`.  This will show you the board's summary and a list of posts.

    +==~~~~~====~~~~====~~~~====~~~~=====~~~~=====~~~~====~~~~====~~~~====~~~~~==+
    Announcements                 
    Important announcements.
    ------------------------------------------------------------------------------
      1       Updates                        Faraday                   12/20/2014 
      2       Happy Holidays                 Faraday                   12/23/2014 
    ------------------------------------------------------------------------------
    Can read: Everyone   Can post: Admin
    +==~~~~~====~~~~====~~~~====~~~~=====~~~~=====~~~~====~~~~====~~~~====~~~~~==+

## Reading a Post

To read a specific post, you use the board name/number and post number.  To read the first message on the Announcements board, you could use `bbs/read 1/1` or `bbs/read announce/1`.

    +==~~~~~====~~~~====~~~~====~~~~=====~~~~=====~~~~====~~~~====~~~~====~~~~~==+          
    Updates                                                               Faraday           
    Announcements (1/1)                                  Sat Dec 20, 2014 10:18pm           
    ------------------------------------------------------------------------------          
    Here are some important updates...
    +==~~~~~====~~~~====~~~~====~~~~=====~~~~=====~~~~====~~~~====~~~~====~~~~~==+

## Reading New Posts

The game will tell you when someone has posted a new message to the BBS.  You will also receive a notification of unread posts when you log in.  You can use the `bbs/new` command to read the first available new post.  You can keep using that command over and over until all the posts are read.

If you've already read the post on another character, or you're just not interested in posts to a particular board, you can use the catchup command to mark all posts on a board as read: `bbs/catchup announce`.

> Tip:  If you link your characters to a [Player Handle](/help/handles), the game will automatically mark a post as read on all your characters when you read it on one.