---
topic: pose format
toc: Communicating
summary: Making poses and emits more readable.
categories:
- main
aliases: 
- autospace
- saycolor
- quotecolor
- nospoof
plugin: pose
---
AresMUSH provides a few commands to help make poses and emits more readable.

The autospace command automatically inserts a blank line or other symbol between poses and pages, to help you tell where one ends and the next begins.  This is particularly helpful when there are multi-line poses.

`autospace <text>` - Sets your autospace text.  Leave blank to clear it.

You can also have Ares colorize text between quotes in poses, to make quotations more visible.  The color code can be found in the `colors` command.  You can also combine colors, so \%xb\%xh will make it bold and blue.

`quotecolor <ansi color code>` - Sets your quotation color.  Leave blank to clear it.

Note!  If you have a player handle (help handles), you can set your autospace and quote color preferences once on AresCentral and that setting will carry over to all your Ares games.

Emit poses are normally anonymous to maintain the flow of the RP text.  If someone is abusing this privilege, you can turn on your "nospoof" setting to identify emits and report the offender to the admin.

`nospoof <on or off>`
