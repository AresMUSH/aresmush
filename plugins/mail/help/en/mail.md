---
toc: 2 - Communicating
summary: In-game mail system.
---
# Mail

The mail system lets you send messages to other players.

> Get an overview of the mail system in the [Mail Tutorial](/help/mail_tutorial).

## Reading Mail

`mail` - View your inbox.
`mail <#>` - Reads a mail message.
`mail/filter <tag>` - Shows mail matching the tag.  Remains in effect until you switch the filter or log out.
`mail/inbox, mail/sent, mail/archive or mail/trash` - Shortcuts to common tag filters.
`mail/scan` - Shows if you have unread mail. You can add this to your [onconnect](/help/onconnect).

## Sending Mail

`mail <to>=<subject>/<message>` - Sends a message.  List multiple player names separated by spaces.
`mail/fwd <#>=<to>/[<comment>]` - Forwards a message, along with an optional comment.

Ares also supports MUX-style mail composition, which lets you write your mail in pieces instead of all at once.

`mail <to>=<subject>` - Starts a mail.   List multiple player names separated by spaces.
`-<message>` - Adds a new paragraph to a message.
`mail/proof` - Shows your mail so far.
`mail/send` or `--` - Sends the mail.
`mail/toss` - Throws away the message you were drafting.

## Replying to Mail

`mail/reply <message>` - Replies to the last message you read.
`mail/reply <#>=<message>` - Replies to a message.

> **Tip:** If you omit the number, it replies to the last message you read (handy if using mail/new).

## Reviewing Sent Mail

`mail/sent` - View your sent mail.

`mail/review <name>` - Shows messages you've sent to someone.
`mail/unsend <name>/<# from mail review>` - Unsends a message if it hasn't already been read.  Use mail/review to find the message number you should use.

## Deleting and Organizing Mail

You can add tags to mail messages to organize them. Most of the organization commands allow you do to a range of messages as well using `<start#>-<end#>`.

`mail/tag <# or #-#>=<tag>` - Adds a tag to a mail message or range of messages.
`mail/untag <# or #-#>=<tag>` - Removes a tag from a mail message or range of messages.
`mail/filter <tag>` - Shows mail matching the tag.  Remains in effect until you switch the filter or log out.

Archived mail shows up under the 'archive' tag, separate from your regular mail.

`mail/archive <# or #-#>` - Clears current tags and applies the Archive tag instead.

Deleting mail puts it into the recycle bin, which is emptied when you log out.

`mail/delete <# or #-#>` - Sends a message or range of messages to the trash.
`mail/undelete <# or #-#>` - Recovers a message or range of messages from the trash.
`mail/emptytrash` - Permanently deletes messages in the trash.

## Reporting Offensive Mails

You can report an offensive mail to the game admin.

`mail/report <#>=<explanation>` - Reports an offensive mail message.
