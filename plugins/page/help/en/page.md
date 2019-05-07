---
toc: 2 - Communicating
summary: Sending private chat messages.
aliases:
- tell
- pm
- pagelock
- abuse
- harassment
- harassed
---
# Pages

Pages are private messages sent between players.  You can page any number of people at once, and use the standard pose formats in the message (like : and ;).

`page <list of names>=<message>`

## Automatic AFK Notice

If you are very idle or marked Away From the Keyboard, people paging you will be notified that you may not respond right away.

## Page Format

You can customize the appearance of pages by changing the color (see [Colors](/help/colors)) of the %% at the beginning as well as autospace text that appears before every page (such as a blank line or other marker).

`page/autospace <text before pages>`
`page/color <ansi code>`

## Reviewing Pages

You can review pages you've sent and received.  Conversations time out after a game-specified period of time to prevent database clutter.

`page/log` - Shows available conversations.
`page/log <names>` - Reviews a conversation.

## Blocking Pages

If someone is annoying you so much you feel the need to block them, you should report them to the game admin.  But while you're waiting for them to deal with it, you can block the harasser by ignoring them.

`page/ignore <name>=<on or off>`

If you don't want to be bothered by pages at all, you can mark yourself as 'do not disturb' and incoming pages will be blocked with a message to the sender.

`page/dnd <on or off>`

## Reporting Pages

If someone is harassing you via pages, you can report them.  

This will automatically include a copy of the pages you select (from page/log) in your report. For example, page/report Bob=12-15/Terrible words!

If the conversation involved multiple players, include all the names from the page/log conversation title in the report.  For example, page/report Bob Mary=12-15/Bob said terrible words!

`page/report <conversation>=<range>/<reason>` - Creates a report.  