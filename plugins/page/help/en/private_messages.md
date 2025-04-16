---
toc: 2 - Communicating
summary: Sending private chat messages.
aliases:
- tell
- page
- pagelock
- pm
- page ignore
- page block
- pm block
- pm ignore
---
# Private Messages (aka PMs or Pages)

Private messages are direct communications between players. Legacy MUs called these 'pages'. The `pm` command is aliased to `p` and `page` so it's familiar to veteran MU players.

> Get an overview of the private message system in the [Chat Tutorial](/help/chat_tutorial).

## Sending and Receiving PMs

`pm <list of names>=<message>` - Send a pm to a list of players.
`pm/reply [<thread #>]=<message>` - Replies to a pm thread. Defaults to your most recent thread, or you can use a thread number from `pm/review`. Note that if another message comes in while you're typing, you'll respond to that one instead!
`pm/review` - Shows available conversations.
`pm/review <names or #>[=<messages to show>]` - Reviews a conversation.
`pm/scan` - Shows if you have unread PMs. You can add this to your [onconnect](/help/onconnect).

> **Note:** Conversations are automatically deleted (after 60 days by default) to prevent database clutter. 

When you PM someone who's offline, idle, AFK, in 'do not disturb' (DND) mode, or on the web portal, it will alert you to their status.

## PM Format

`pm/autospace <text before messages>` - Format the text that appears before each PM (using a blank line or other marker).
`pm/color <ansi code>` - Customize the color of the PM marker.

## Muting PMs

You can put yourself in 'do not disturb' mode while you're RPing, or block PMs from someone you don't want to hear from. They will receive a failure message if they try to PM you.

`pm/dnd <on or off>` - Turns 'do not disturb' mode on or off.
`block <char>=<type>/<on or off>` - Use type 'pm' to block private messages from the character.

## Reporting PMs

If someone is harassing you in PMs, you can report them.  This will automatically include a copy of the messages in your report. You select which message to start from (using the message numbers in pm/review). The report will include messages from that point to the time of the report.

`pm/report <conversation>=<message # to start with>/<reason>` - Creates a report of inappropriate messages.  
  
> **Tip:** You have to use the full conversation title in the report if it involves multiple people.  For example, pm/report Bob Mary=12/Bob said terrible things!