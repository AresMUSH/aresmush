---
toc: Communicating
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

You can customize the appearance of pages by changing the color (see [Colors](/help/colors)) of the %% at the beginning as well as autospace text that appears before every page (such as a blank line or other marker).

`page/autospace <text before pages>`
`page/color <ansi code>`

## Automatic AFK Notice

If you are very idle or marked Away From the Keyboard, people paging you will be notified that you may not respond right away.  You can control the specific message they receive using the [afk](/help/afk) command.

If you don't want to be bothered by pages at all, you can mark yourself as 'do not disturb' and incoming pages will be blocked with a message to the sender.

`page/dnd <on or off>`

## Blocking & Monitoring Pages

If someone is annoying you so much you feel the need to block them, you should report them to the game admin.  But while you're waiting for them to deal with it, you can block the harasser by ignoring them. You can also enable page monitoring.  This will keep track of the last couple dozen pages to and from that person.  The other person will not be notified that you are logging pages.  

`page/ignore <name>=<on or off>`
`page/monitor` - Shows who you're monitoring.
`page/monitor <name>=<on or off>` - Starts or stops monitoring pages from someone.
`page/log <name>` - Review your page log with someone.  This is what will be included if you report them.
`page/report <name>=<reason>` - Creates a report, including your page log with that person as evidence.
