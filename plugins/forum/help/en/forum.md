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
---
# Forums

Inspired by the widely-loved [Myrrdin’s Bulletin Board System](http://www.firstmagic.com/~merlin/mushcode/mc.bb.html), the Ares Forum provides MU-wide discussion topics, available in-game and on the web portal.

> **Tip:** For all of the forum commands, you can specify either the category name or number.  Those familiar with Myrddin's BBS should find that the commands you're used to (bbread, bbpost, etc.) also work here.

The 'rw' on the end tells you whether you can read and/or write to that category.

## Listing Categories

The forum has a variety of categories, each with a different purpose.  You can see the list of categories and their descriptions.

To view topics in a category, you need to use the `forum` command with the category name or number.  For example: to read the announcements category you could use either `forum 1` or `forum announcements`.

`forum` - Lists available categories.
`forum <category>` - Lists posts on the selected category.
`forum <category>/<topic #>` - Reads the selected topic.
  
## Hiding Categories

If there are forum categories you don't use, you can hide them from the list and suppress notifications of new posts there.

`forum/hide <category>` and `forum/unhide <category>` - Hide or show a category.

## Reading New Posts

The game will tell you when someone has posted a new message to the forum.  You will also receive a notification of unread posts when you log in.  You can use the `forum/new` command to read the first available new post.  You can keep using that command over and over until all the posts are read.

If you've already read the post on another character (or you're just not interested in posts to a particular category) you can use the catchup command to mark all posts in a category as read.

> Tip:  If you link your characters to a [Player Handle](/help/handles), the game will automatically mark a post as read on all your characters when you read it on one.

`forum/new` - Reads the first unread message on any category.
`forum/catchup <category>` - Marks all unread messages in that category as read.

## Start a Topic

To start a new discussion topic, use the `forum/post` command with the category name/number, a title and a message.

`forum/post <category>=<title>/<body>` - Creates a new topic.

## Replying to Topic

The forum lets you carry on a thread of conversation by replying to posts.  Replies show up underneath the original message when you read it.

`forum/reply <category name or number>/<topic number>=<reply>` - Replies to a forum topic.
`forum/reply <reply>` - Replies to the last post you read.
  
## Notifications

When RPing, you may want to mute forum notifications.  This will last until your next login.

`forum/mute` and `forum/unmute` - Mutes notifications until your next login.

## Editing and Deleting Posts

For help editing and deleting forum posts, see [Forum Editing](/help/forum_edit).