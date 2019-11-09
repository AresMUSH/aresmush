---
toc: 4 - Writing the Story
summary: Making poses and emits more readable.
aliases:
- autospace
- saycolor
- quotecolor
- textcolor
- posecolor
- posebreak
- tepecolor
- tepe
---
# Formatting Poses

AresMUSH provides a few commands to help make poses and emits more readable.

**If you have a player handle (help handles), you can set your autospace and quote color preferences once on AresCentral and that setting will carry over to all your Ares games.**

The autospace command automatically inserts a blank line or other symbol between poses and pages, to help you tell where one ends and the next begins.  This is particularly helpful when there are multi-line poses. Autospace can contain formatting codes and `%n` to include the poser's name.

`autospace <text>` - Sets your autospace text.  Leave blank to clear it.

> Note: This applies only to poses.  There is another command (see [Pages](/help/page)) that lets you format a similar autospace before pages and OOC remarks.

## Quote Color

You can also have Ares colorize text between quotes in poses, to make quotations more visible.  The color code can be found in the `colors` command.  You can also combine colors, so \%xb\%xh will make it bold and blue.

`quotecolor <ansi color code>` - Sets your quotation color.  Leave blank to clear it.
`tepecolor <ansi color code>` - Sets your telepathy color.  Leave blank to clear it.
