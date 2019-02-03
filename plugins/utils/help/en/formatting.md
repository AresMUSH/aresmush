---
toc: Formatting Text
summary: Using formatting and substition codes.
aliases:
- subs
- formatting
- linebreak
- center
---
# Text Formatting

Ares provides a number of formatting codes, which can be used pretty much anywhere: templates, poses, descriptions, and more.  

## Escaping Characters

Ares does not treat brackets, parens or % signs as special characters (unless the % is one of the special sequences listed above). 

    echo I don't have to do anything special to see a [ ] or a %.
   
If you did want to page someone one of the special codes, just put a \ in front of it.

    echo Escape \\%xb with a backslash so I don't turn my text blue.

## Format Codes

    \%r - A linebreak
    \%b - A single blank space
    \%t - Five blank spaces (like a tab)
    \%lh, \%lf, \%ld, \%la - One of the border lines - header, footer, divider, alt-divider

\%x or \%c are used for ansi color.  See [Ansi](/help/ansi).

## Functions

Ares in general doesn't support functions the way you're used to from MUSHCode.  But there is **limited** support for a few for backwards-compatibility. 

    [space(<number of spaces>)] - blank spaces
    [center(<text>,<length>,<optional padding string>)] - center text
    [left(<text>,<length>,<optional padding string>)] - left align text
    [right(<text>,<length>,<optional padding string>)] - right a lign text
    \[ansi(<code>,<text>)] - ansify text