---
toc: Web Portal
summary: Using Markdown text.
---

# Markdown Formatting

Most text blocks in the web portal accept [Markdown formatting](https://daringfireball.net/projects/markdown/syntax).  Markdown is a markup language that is designed to be readable even when displayed in plain text, making it ideal for text that can also be viewed on the MUSH itself.

[[toc]]

## Basic Markdown

You can view the complete Markdown syntax [here](https://daringfireball.net/projects/markdown/syntax).  A few of the most common formatting options are shown below for easy reference:

`**bold text**`
`_italics text_` 
`[Link Title](http://somewhere.com)`
`![Image Alt Text](/files/pic.jpg)`  (you can also use the pretty image tag, described below)
`# Heading 1`
`## Heading 2`
`* List Item`

In addition to the basic Markdown syntax, Ares supports several custom extensions.


## Wikidot Italics

You can use slashes for italics too:

`//alternate italics//` 

## Wikidot Links

You can use wikidot style links to link to a page on the wiki:

`[[[Wiki Page Name]]]`

Category text will automatically be trimmed from the link title (e.g. theme:overview will simply be shown as 'Overview') but you can also specify a completely different link title:

`[[[Wiki Page Name|Display Title]]]`

Finally you can link to external pages.

`[http://somewhere Link Title]`

## Music Player

The built-in music player (based on a WikiDot version by @Blu) lets you add the sound from a YouTube video to your page with a start/stop play button.  All you need is the YouTube video ID.

`[[musicplayer E5TsA6CHpII Description]]`


## Pretty Images

For a basic image, the regular markdown syntax will suffice:

`![Image Alt Text](/files/pic.jpg)`

You can display images with some easy formatting options, including height, width and alignment (left, right or center).  All of the formatting options can be omitted.

`[[image /files/pic.jpg height=50px width=100px center]]`


## Tables

You can use the extended table syntax for easy tables.

    | Title 1 | Title 2 | 
    |-----    |-----    | 
    | Text    | Text    | 

## Scene, Page and Character Lists

You can include a gallery of characters, a table of scenes, or a list of wiki pages matching certain tags.

`[[chargallery navy]]`
`[[pagelist theme]]`
`[[scenelist action]]`

In all cases you can list multiple tags, separated by spaces.   

Tag names may be prefixed with a hyphen to exclude the tag.  By default, multiple tags use an "OR" operation, but you can make it an "AND" operation by including a + in front of the tag name. 

* "picon navy" would include characters with the Picon tag _or_ the Navy tag.
* "picon -navy" would include characters with the Picon tag and _not_ the Navy tag.
* "picon +navy" would include characers with the Picon tag _and_ the Navy tag.
* "picon caprica +navy" would include characters with _either_ the Picon/Caprica tags _and_ the Navy tag.

## Tabs

You can include a tab view with multiple tab selections.

`[[tabview]]` 
`[[tab Title1]]` 
`Some text.`
`[[/tab]]` 
`[[tab Title2]]` 
`Some other text.`
`[[/tab]]` 
`[[/tabview]]` 

## Including Other Pages

If you have a common snippet that you want to use in multiple places, you can put it into a wiki page of its own and then include it in other pages with the include tag.

`[[include PageName]]`

You can use includes like templates by creating placeholders where variables will go.  Inside the wiki page, make a placeholder like so with a variable name:  `%{foo}`.  Then when you use the include, set the variable like so:

`[[include PageName`
`|foo=Foo Value`
`]]`

In the page, `%{foo}` will be replaced with "Foo Value".  Be sure to put only one variable per line, and start the line with |.


## Table of Contents

You can include an auto-generated table of contents with level 2 and 3 headers.  (Level 1 is excluded because it's always the page title.)

`[[toc]]`

