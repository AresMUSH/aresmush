---
toc: 2 - Communicating
summary: Reading the discussion forums.
aliases:
- bulletin board
- bbread
- bbpost
- bbmisc
- bbreply
- board
- bbs
- bbedit
- bbmove
- bbdelete
---
# Forum Commands

Inspired by the widely-loved [Myrrdin’s Bulletin Board System](http://www.firstmagic.com/~merlin/mushcode/mc.bb.html), the Ares Forum provides MU-wide discussion topics, available in-game and on the web portal.

> Learn how the forum system works in the [Forum Tutorial](/help/forum_tutorial).

## Viewing Forum Categories

> **Tip:** For all of the forum commands, you can specify either the category name or number.  Those familiar with Myrddin's BBS should find that the commands you're used to (bbread, bbpost, etc.) also work here.

`forum` - Lists available categories.
`forum <category>` - Lists posts on the selected category.
`forum <category>/<topic #>` - Reads the selected topic.   You can also specify a range of topics (e.g. 2-5)
`forum/hide <category>` - Hide a category so it won't show up on forum/scan or the portal list.
`forum/unhide <category>` - Show a hidden category.

## Reading Posts

`forum/new` - Reads the first unread message on any category.
`forum/catchup <category>` - Marks all unread messages in that category as read.
`forum/mute` - Mutes notifications about a forum until your next login.
`forum/unmute` - Unmutes notifications.

> Tip:  If you link your characters to a [Player Handle](/help/handles), the game will automatically mark a post as read on all your characters when you read it on one.

## Posting and Replying

`forum/post <category>=<title>/<body>` - Creates a new topic.
`forum/reply <category name or number>/<topic number>=<reply>` - Replies to a forum topic.
`forum/reply <reply>` - Replies to the last post you read.
  
## Editing, Moving and Deleting Posts

You can edit, move and delete your own forum posts.  Forum administrators with the **can\_manage\_forum** permission are able to manage other peoples' posts and replies as well.

`forum/edit <category>/<post #>=<new text>` - Replaces post text with the new text.
`forum/edit <category>/<post #>` - Grabs the existing post text into your input buffer. (if your client supports the [Edit Feature](/help/edit)).
`forum/move <category>/<post #>=<new category>` - Moves a post from one category to another.
`forum/delete <category>/<post #>` - Deletes a topic and all of its replies.
`forum/editreply <category name or number>/<post number>/<reply number>/<new text>` - Edits a reply.
`forum/deletereply <category name or number>/<post number>/<reply number>` - Deletes a forum reply.