---
topic: formatting
toc: Misc
summary: Formatting and substition codes.
categories:
- main
aliases:
- subs
- formatting
- linebreak
- center
plugin: utils
---
Ares provides a number of formatting codes, which can be used pretty much anywhere: templates, poses, descriptions, and more.  

A complete list can be found here:  http://aresmush.com/formatting

Some commonly used ones are:

    \%r - A linebreak
    \%x or \%c - Ansi color (see `help ansi`)
    \%b - A single blank space
    \%t - Five blank spaces (like a tab)
    \%l1, \%l2, \%l3, \%l4 - Shows one of the border lines.

It is worth noting that Ares does not treat brackets, parens or % signs as special characters (unless the % is one of the special sequences listed above). 

   echo I don't have to do anything special to see a [ ] or a %.
   
If you did want to page someone one of the special codes, just put a \ in front of it.

   echo Escape \\%xb with a backslash so I don't turn my text blue.
