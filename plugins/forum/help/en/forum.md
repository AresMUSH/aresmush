---
toc: Communicating
summary: Reading the discussion forums.
aliases:
- bulletin board
- bbread
- bbpost
- bbmisc
- bbreply
- bbedit
- board
- bbs
- reply
---
# Forums

The Ares Forum provides MU-wide discussion topics, available in-game and on the web portal.

**Tip:** For all of the forum commands, you can specify either the category name or number.  Other commands you're used to (bbread, bbpost, etc.) also work here.

**Tip:** You can read, write, and reply to forum posts on the web portal.

## Reading Forums
`forum` - Lists available categories.
`forum <category>` - Lists posts on the selected category.

'rw' tells you whether you can read and/or write to that category.

## Hiding Categories & Muting Notifications

You can hide categories and mute notifications of new posts.

`forum/hide <category>`  - Hide a category.
`forum/unhide <category>` - Show a hidden category.
`forum/mute` - Mutes all forum notifications until your next login.
`forum/unmute` - Unutes notifications.

## Reading Topics

To read a specific topic, you use the category name/number and topic number.  To read the first message in the Announcements category, you could use `forum 1/1` or `forum announce/1`.

`forum <category>/<topic #>` - Reads the selected topic.
`forum/new` - Reads the first unread message on any category.
`forum/catchup <category>` - Marks all unread messages in that category as read.

## Writing & Editing Posts

`forum/post <category>=<title>/<body>` - Creates a new topic.

`forum/edit <category>/<post #>=<new text>` - Replaces post text with the new text.
`forum/edit <category>/<post #>` - Grabs the existing post text into your input buffer.

`forum/reply <category name or number>/<topic number>=<reply>` - Replies to a forum topic.
`forum/reply <reply>` - Replies to the last post you read.

### Managing Posts

`forum/move <category>/<post #>=<new category>` - Moves a post from one category to another.
`forum/delete <category>/<post #>` - Deletes a topic

Forum administrators with the **can\_manage\_forum** permission are able to delete other people's replies.

`forum/deletereply <category name or number>/<post number>=<reply number>` - Deletes a forum reply.
