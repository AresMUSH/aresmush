---
toc: Utilities / Miscellaneous
summary: Ansi colors.
aliases:
- color
- colors
- fansi
---
# Ansi Color
Ares' formatting lets you add color to your text. See [formatting options](https://aresmush.com/tutorials/code/formatting.html) for details.

Ares supports the standard Penn/Tiny ANSI color codes (g for green, b for blue, c for cyan, etc.) as well as extended codes for FANSI support.  FANSI allows 256 colors, but it its not supported on all clients. You can choose which mode you want to use, and also see how each color will appear.

`colors <fansi, ansi, none>` - Changes what colors you see.
`colors` - View all color codes as they appear in your client. 

You can set color in text using either \%x or \%c followed by the color code.  \%xn goes back to normal.  Ansi codes can also be nested within each other. 

  \%xgGreen\%xn --> %xgGreen%xn.
  \%xrRed on black\%xBRed on Blue\%xnBack to normal -->  %xrRed on black%xBRed on Blue%xnBack to normal

And codes like bold and underline can be stacked with other colors.

  \%xh\%xbHighlighted blue.\%xn --> %xh%xbHighlighted blue.%xn

Additional ansi codes include:

    \%x! - A random color
    \%xu and %xU - Start and end underline (doesn't affect colors)
    \%xU - End underline (but doesn't affect color)
    \%xi and \%xI - Begin and end inverse colors (reversing foreground and background)
    \%xh and \%xH - Begin and end highlight/bold (does not affect color)
    \%xn - Ends all formatting
    
(https://aresmush.com/tutorials/code/formatting.html)