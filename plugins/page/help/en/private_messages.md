---
toc: 2 - Communicating
summary: Sending private chat messages.
aliases:
- tell
- page
- pagelock
- pm
---
# Private Messages (aka PMs or Pages)

Pages are private messages sent between players. The `pm` command is aliased to `p` and `page` so it's familiar to veteran MU players.

> Get an overview of the private message system in the [Chat Tutorial](/help/chat_tutorial).

## Sending and Receiving Pages

`pm <list of names>=<message>` - Send a pm to a list of players.
`pm/review` - Shows available conversations.
`pm/review <names>` - Reviews a conversation.

> **Note:** Conversations are automatically deleted (after 60 days by default) to prevent database clutter. 

When you page someone who's offline, idle, AFK, in 'do not disturb' (DND) mode, or on the web portal, it will alert you to their status.

## Page Format

`pm/autospace <text before pages>` - Format the text that appears before each page (using a blank line or other marker)
`pm/color <ansi code>` - Customize the color of the PM marker.

## Blocking and Reporting Pages

You can block pages from someone you don't want to hear from, or put yourself in 'do not disturb' mode while you're RPing. If someone is harassing you in pages, you can report them.  This will automatically include a copy of the pages you select (from page/review) in your report.

`pm/dnd <on or off>` - 
`pm/ignore <name>=<on or off>` - Blocks messages from a player.
`pm/report <conversation>=<range of messages from page review>/<reason>` - Creates a report of inapprpriate messages.  
  
> **Tip:** You have to use the full conversation title in the report if it involves multiple people.  For example, page/report Bob Mary=12-15/Bob said terrible things!