---
summary: Replying to BBS messages.
toc: Bulletin Boards
aliases: 
---
# BBS - Replying to Posts

The BBS system lets you carry on a thread of conversation by replying to posts.  Replies show up underneath the original post when you read it.

    +==~~~~~====~~~~====~~~~====~~~~=====~~~~=====~~~~====~~~~====~~~~====~~~~~==+          
    Jungle Crew                                                           Faraday           
    Discussions (3/4)                                    Sat Mar 25, 2017 11:19pm           
    ------------------------------------------------------------------------------          
    Here is the first post.          
    ------------------------------------------------------------------------------          
    (1) Mikolas replied on Sat Mar 25, 2017 11:20pm         
    A reply!           
    ------------------------------------------------------------------------------          
    (2) Tamlin replied on Mon Mar 27, 2017  8:30pm          
    Another reply!       
    ------------------------------------------------------------------------------          
    (3) Faraday replied on Tue Mar 28, 2017  9:58pm         
    A third reply!   
    +==~~~~~====~~~~====~~~~====~~~~=====~~~~=====~~~~====~~~~====~~~~====~~~~~==+ 

To reply to a message, use the board name/number, post number and your response: `bbs/reply 3/4=My reply.`

If you've just read a post, you can reply to it without specifying the name and number.  Just give a message and it will reply to the last post you've read: `bbs/reply My reply.`

## Deleting Replies

You cannot edit a reply once it's been posted, but you can delete it and try again.  Use the deletereply command with the board, post and reply number:  `bbs/deletereply 3/4=1`

Board administrators with the **can\_manage\_board** permission are able to delete other people's replies.
