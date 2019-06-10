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

## Page Review

You can review pages you've missed, including ones that happened when you were offline. You will be notified of missed pages when you log in.

> Note: Conversations are automatically deleted (after 60 days by default) to prevent database clutter. 

`page/review` - Shows available conversations.
`page/review <names>` - Reviews a conversation.
  
## Page Status Indicators

When you page someone who's offline/AFK/etc in-game, it will alert you to their status.

    <PM> (to Faraday<AFK>) Cate says, "Hiya"

AFK = Away from Keyboard; OFF = Offline; DND = Do not disturb; a time like 2h indicates they're idle

## Page Format

You can customize the appearance of pages by changing the color (see [Colors](/help/colors)) of the %% at the beginning as well as autospace text that appears before every page (such as a blank line or other marker).

`page/autospace <text before pages>`
`page/color <ansi code>`

## Blocking and Reporting Pages

You can block pages from someone you don't want to hear from.

`page/ignore <name>=<on or off>`

If someone is harassing you in pages, you can report them.  This will automatically include a copy of the pages you select (from page/review) in your report. For example, page/report Bob=12-15/Terrible things!  You have to use the full conversation title in the report if it involves multiple people.  For example, page/report Bob Mary=12-15/Bob said terrible things!

`page/report <conversation>=<range>/<reason>` - Creates a report.  

## Do Not Disturb Mode

Do not disturb mode prevents your MUSH client window from seeing pages while you're RPing.  You'll still see a notification of the missed pages the next time you log in, and can review them with page/review.  Do not disturb does not affect pages received on the web portal.

`page/dnd <on or off>`
