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

## Deleting and Archiving Mail

`mail/archive <#>` - Clears current tags and applies the Archive tag instead.
`mail/delete <#> or <start#>-<end#>` - Sends a message to the trash.
`mail/undelete <#>` - Recovers a message from the trash.
`mail/emptytrash` - Permanently deletes messages in the trash.

> **Tip:** The trash is emptied when you log out, so you can recover a message until then.

## Reporting Offensive Mails

You can report an offensive mail to the game admin.

`mail/report <#>=<explanation>` - Reports an offensive mail message.
