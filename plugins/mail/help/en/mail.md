---
toc: 2 - Communicating
summary: In-game mail system.
---
# Mail

The **Mail System** lets you send messages to players who are not online, similar to email.

## Reading Mail

You can view your mail messages simply by using the mail command.

`mail` - View your inbox.
`mail <#>` - Reads a mail message.

## Sending Mail

Sending mail is easy. The "to" field can include any number of player names, separated by spaces. You can also forward a message from your inbox to someone else.

`mail <to>=<subject>/<message>` - Sends a message.

Ares also supports MUX-style mail composition, which lets you write your mail in pieces instead of all at once.

`mail <to>=<subject>` - Starts a mail.
`-<message>` - Adds a new paragraph to a message.
`mail/proof` - Shows your mail so far.
`mail/send` or `--` - Sends the mail.
`mail/toss` - Throws away the message you were drafting.

## Forwarding Mail

You can also forward mail.

`mail/fwd <#>=<to>/<comment>` - Forwards a message, along with an optional comment.

## Replying to Mail

When replying, you can use 'reply' or 'replyall' to reply to just the author or everyone on the message.  If you omit the number, it replies to the last message you read (handy if using mail/new).

`mail/reply <message>` - Replies to the last message you read.
`mail/reply <#>=<message>` - Replies to a message.

## Reviewing Sent Mail

There are two ways to handle sent mail on Ares.   The first is to automatically CC yourself on all messages you send.  Messages you send will automatically appear in your "Sent" folder (available through mail/sent).

`mail/sentmail <on or off>` - Turns sent mail copy on or off.

You can also use the mail review feature to review messages you've sent to particular people, as long as they haven't been deleted.  Once someone deletes your message, it will no longer show up in the mail review list.  

`mail/review <name>` - Shows messages you've sent to someone.
`mail/unsend <name>/<#>` - Unsends a message if it hasn't already been read.

## Deleting and Archiving Mail

You can delete mail messages.  Technically this doesn't delete it right away, but tags it as trash.  Messages tagged as trash are deleted when you log out.

`mail/delete <#> or <start#>-<end#>` - Sends a message to the trash.
`mail/undelete <#>` - Recovers a message from the trash.
`mail/emptytrash` - Permanently deletes messages in the trash.

Instead of deleting a mail message, you can archive it.

`mail/archive <#>` - Clears current tags and applies the Archive tag instead.
