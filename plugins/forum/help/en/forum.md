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
---
# Forums

Inspired by the widely-loved [Myrrdin’s Bulletin Board System](http://www.firstmagic.com/~merlin/mushcode/mc.bb.html), the Ares Forum provides MU-wide discussion topics, available in-game and on the web portal.

> **Tip:** For all of the forum commands, you can specify either the category name or number.  Those familiar with Myrddin's BBS should find that the commands you're used to (bbread, bbpost, etc.) also work here.

The 'rw' on the end tells you whether you can read and/or write to that category.

## Reading Forums

### Listing Categories

The forum has a variety of categories, each with a different purpose.  You can see the list of categories and their descriptions.

To view topics in a category, you need to use the `forum` command with the category name or number.  For example: to read the announcements category you could use either `forum 1` or `forum announcements`.  You can also use part of the category name as long as it's enough to distinguish which category you're after:  `forum announce`.  This will show you the category's summary and a list of topics.

`forum` - Lists available categories.
`forum <category>` - Lists posts on the selected category.
  
## Hiding Categories

If there are forum categories you don't use, you can hide them from the list and suppress notifications of new posts there.

`forum/hide <category>` and `forum/unhide <category>` - Hide or show a category.

## Reading Topics

To read a specific topic, you use the category name/number and topic number.  To read the first message in the Announcements category, you could use `forum 1/1` or `forum announce/1`.

`forum <category>/<topic #>` - Reads the selected topic.

### Reading All New Posts

The game will tell you when someone has posted a new message to the forum.  You will also receive a notification of unread posts when you log in.  You can use the `forum/new` command to read the first available new post.  You can keep using that command over and over until all the posts are read.

If you've already read the post on another character (or you're just not interested in posts to a particular category) you can use the catchup command to mark all posts in a category as read.

> Tip:  If you link your characters to a [Player Handle](/help/handles), the game will automatically mark a post as read on all your characters when you read it on one.

`forum/new` - Reads the first unread message on any category.
`forum/catchup <category>` - Marks all unread messages in that category as read.

## Start a Topic

To start a new discussion topic, use the `forum/post` command with the category name/number, a title and a message.

`forum/post <category>=<title>/<body>` - Creates a new topic.

### Editing a Post

If you need to edit a post after it's been posted, you can use the edit command to either replace the text completely or grab it into your input buffer (if your client supports the [Edit Feature](/help/edit)).

`forum/edit <category>/<post #>=<new text>` - Replaces post text with the new text.
`forum/edit <category>/<post #>` - Grabs the existing post text into your input buffer.

### Moving a Topic

You can move a topic from one category to another using the move command.

`forum/move <category>/<post #>=<new category>` - Moves a post from one category to another.

### Deleting a Topic

To delete a topic completely, including all of its replies, use the delete command.

`forum/delete <category>/<post #>` - Deletes a topic

## Replying to Topic

The forum lets you carry on a thread of conversation by replying to posts.  Replies show up underneath the original message when you read it.

`forum/reply <category name or number>/<topic number>=<reply>` - Replies to a forum topic.
`forum/reply <reply>` - Replies to the last post you read.

### Deleting Replies

You cannot edit a reply once it's been posted, but you can delete it and try again.

Forum administrators with the **can\_manage\_forum** permission are able to delete other people's replies.

`forum/deletereply <category name or number>/<post number>=<reply number>` - Deletes a forum reply.
  
### Notifications

When RPing, you may want to mute forum notifications.  This will last until your next login.

`forum/mute` and `forum/unmute` - Mutes notifications until your next login.