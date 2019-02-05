---
toc: 2 - Communicating
summary: Editing and organizing forum posts.
aliases:
- bbedit
- bbmove
- bbdelete
---
# Organizing Forum Posts

You can edit, move and delete your own forum posts.  Forum administrators with the **can\_manage\_forum** permission are able to manage other peoples' posts and replies as well.

## Editing a Post

If you need to edit a post after it's been posted, you can use the edit command to either replace the text completely or grab it into your input buffer (if your client supports the [Edit Feature](/help/edit)).

`forum/edit <category>/<post #>=<new text>` - Replaces post text with the new text.
`forum/edit <category>/<post #>` - Grabs the existing post text into your input buffer.

## Moving a Topic

You can move a topic from one category to another using the move command.

`forum/move <category>/<post #>=<new category>` - Moves a post from one category to another.

## Deleting a Topic

To delete a topic completely, including all of its replies, use the delete command.

`forum/delete <category>/<post #>` - Deletes a topic
  
## Deleting Replies

You cannot edit a reply once it's been posted, but you can delete it and try again.

`forum/deletereply <category name or number>/<post number>=<reply number>` - Deletes a forum reply.