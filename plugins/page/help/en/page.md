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

Pages are private messages sent between players.  You can page any number of people at once, and use the standard pose formats in the message (like : and ;).  You can also send and receive pages via the web portal.

`page <list of names>=<message>`

You can customize the appearance of pages by changing the color (see [Colors](/help/colors)) of the %% at the beginning as well as autospace text that appears before every page (such as a blank line or other marker).

`page/autospace <text before pages>`
`page/color <ansi code>`

## Automatic AFK Notice

If you are very idle or marked Away From the Keyboard, people paging you will be notified that you may not respond right away.  You can control the specific message they receive using the [afk](/help/afk) command.

If someone is harassing you in pages, you can report them.  This will automatically include a copy of the pages you select (from page/review) in your report. For example, page/report Bob=12-15/Terrible things!  You have to use the full conversation title in the report if it involves multiple people.  For example, page/report Bob Mary=12-15/Bob said terrible things!

`page/dnd <on or off>`

## Blocking & Monitoring Pages

If someone is harassing you via pages, you can enable page monitoring.  This will keep track of the last couple dozen pages to and from *just* that person.  The other person will *not* be notified that you are logging pages.

Do not disturb mode prevents your MUSH client window from seeing pages while you're RPing.  You'll still see a notification of the missed pages the next time you log in, and can review them with page/review.  Do not disturb does not affect pages received on the web portal.

`page/ignore <name>=<on or off>`
`page/monitor` - Shows who you're monitoring.
`page/monitor <name>=<on or off>` - Starts or stops monitoring pages from someone.
`page/log <name>` - Review your page log with someone.  This is what will be included if you report them.
`page/report <name>=<reason>` - Creates a report, including your page log with that person as evidence.
