---
toc: Communicating
summary: Posting BBS messages.
---
# BBS - Posting to Boards

To post a message to a board, you use the `bbs/post` command with the board name/number, a title and a message.

`bbs/post <board>=<title>/<body>` - Writes a new post.

## Editing a Post

If you need to edit a post after it's been posted, you can use the edit command with the board name/number and the post number.  This will replace the post title and message with the new text.

If your client supports the [Edit Feature](/help/utils/edit), you can use the edit command with just the board and post number to grab the post text into your client's input buffer: `bbs/edit 1/6`

`bbs/edit <board>/<post #>=<new text>` - Replaces post text with the new text.
`bbs/edit <board>/<post #>` - Grabs the existing post text into your input buffer.

## Moving a Post

You can move a post from one board to another using the move command.  Just specify the original board and post number, and the new board name/number.

`bbs/move <board>/<post #>=<new board>` - Moves a post from one board to another.

## Deleting a Post

To delete a post completely, including all of its replies, use the delete command with the board name/number and post number.

`bbs/delete <board>/<post #>` - Deletes a post