---
summary: Posting BBS messages.
toc: Bulletin Boards
aliases: 
categories:
- main
---
# BBS - Posting to Boards

To post a message to a board, you use the `bbs/post` command with the board name/number, a title and a message:  `bbs/post 1/Some Updates=Here are some updates.`

## Editing a Post

If you need to edit a post after it's been posted, you can use the edit command with the board name/number and the post number.  For example, if the post we just made was the sixth post on board 1, you could do:   `bbs/edit 1/6=Some Updates take 2/Here are some different updates.`  This will replace the post title and message with the new text.

If your client supports the [Edit Feature](/help/utils/edit), you can use the edit command with just the board and post number to grab the post text into your client's input buffer: `bbs/edit 1/6`

## Moving a Post

You can move a post from one board to another using the move command.  Just specify the original board and post number, and the new board name/number:  `bbs/move 1/6=2` will move message 6 from board 1 to board 2.

## Deleting a Post

To delete a post completely, including all of its replies, use the delete command with the board name/number and post number:  `bbs/delete 1/6`.

## Editing Other Players' Posts

Board administrators with the **can\_manage\_board** permission are able to move and edit other peoples' posts.  Otherwise, you can only edit your own.

