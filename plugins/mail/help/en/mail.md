---
toc: Communicating
summary: In-game mail system.
---
# Mail

The **Mail System** lets you send messages to players who are not online, similiar to email.

## Reading Mail
`mail` - View your inbox.
`mail <#>` - Reads a mail message.

## Sending Mail

`mail <to>=<subject>/<message>` - Sends a message. The "to" field can include any number of player names, separated by spaces.

Ares also supports MUX-style mail composition, which lets you write your mail in pieces instead of all at once.
`mail <to>=<subject>` - Starts a mail.
`-<message>` - Adds a new paragraph to a message.
`mail/proof` - Shows your mail so far.
`mail/send` or `--` - Sends the mail.
`mail/toss` - Throws away the message you were drafting.

`mail/fwd <#>=<to>/<comment>` - Forwards a message, along with an optional comment.
`mail/reply[all] <message>` - Replies to the last message you read.
`mail/reply[all] <#>=<message>` - Replies to a message.

## Reviewing Sent Mail
`mail/sentmail <on or off` - Turns sent mail copy on or off. On by default.
`mail/sent` - View mails you have sent.
`mail/review <name>` - Shows messages you've sent to someone.
`mail/unsend <name>/<#>` - Unsends a message if it hasn't already been read.

## Organizing  Mail

Ares mail uses `tags`, which are labels used to organize your mail.  You can make your own custom tags to organize your messages. There are also several special tags:

Inbox - Incoming mail.
Sent - If you've enabled the sent-mail feature, saves a copy of mail you've sent.
Trash - Mail you've marked for deletion.
Archive - Mail you've archived to keep it from cluttering up the inbox.

`mail/tag <#>=<tag>` - Assigns a tag to a message.
`mail/untag <#>=<tag>` - Removes a tag from a message.
`mail/tags` - Lists all your tags.

`mail/filter <tag>` - Shows mail matching the tag.
`mail/inbox, mail/sent, mail/archive or mail/trash` - Shortcuts to common tag views.

## Deleting and Archiving Mail

Messages in trash are deleted when you log out.

`mail/delete <#> or <start#>-<end#>` - Sends a message to the trash.
`mail/undelete <#>` - Recovers a message from the trash.
`mail/emptytrash` - Permanently deletes messages in the trash.

`mail/archive <#>` - Clears current tags and applies the Archive tag instead.

`mail/backup` - Prints out your mail, which you can save to a log file.

## Requests/Jobs and Mail
**Admin Only**
Admins can convert a mail message into a job.

`mail/job <#>` - Turns a mail message into a job request.
