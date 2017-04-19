---
toc: Mail
summary: Sending mail.
aliases:
- reply
- forward
- fwd
---
# Sending Mail

Sending mail is easy. The "to" field can include any number of player names, separated by spaces. You can also forward a message from your inbox to someone else.

`mail <to>=<subject>/<message>` - Sends a message.

You can automatically CC yourself on messages you sent by enabling the sent-mail feature.  Messages you send will automatically appear in your "Sent" folder (available through mail/sent).

`mail/sentmail <on or off` - Turns sent mail copy on or off.

## Forwarding Mail

You can also forward mail.

`mail/fwd <#>=<to>/<comment>` - Forwards a message, along with an optional comment.

## Replying to Mail

When replying, you can use 'reply' or 'replyall' to reply to just the author or everyone on the message.  If you omit the number, it replies to the last message you read (handy if using mail/new).

`mail/reply <message>` - Replies to the last message you read.
`mail/reply <#>=<message>` - Replies to a message.

Ares also supports MUX-style mail composition, which lets you write your mail in pieces instead of all at once.  See [Mail Composition](/help/mail/composition).
