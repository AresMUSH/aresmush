---
toc: Formatting Text
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

## Image Gallery

You can include a gallery of images (similar to what appears on the character profile pages).  Just list the folder and filename, one per line.

`[[gallery]]`
`folder/image1.jpg`
`folder/image2.jpg`
`[[/gallery]]`

## Music Player

The built-in music player (based on a WikiDot version by @Blu) lets you add the sound from a YouTube video to your page with a start/stop play button.  All you need is the YouTube video ID.

Note: The music player only works on character pages.

`[[musicplayer E5TsA6CHpII Description]]`

## Collapsible Text

Collapsibles let you show and hide text with the click of a button.

`[[collapsible button text]]`
`Text you want to show and hide.`
`[[/collapsible]]`

## Pretty Images

For a basic image, the regular markdown syntax will suffice.  Note that images live in the `game/uploads` folder.

`![Image Alt Text](/game/uploads/misc/pic.jpg)`

You can display images with some easy formatting options, including height, width and alignment (left, right or center).  All of the formatting options can be omitted.

`[[image /game/uploads/pic.jpg height=50px width=100px center]]`


## Tables

You can use the extended table syntax for easy tables.

`| Title 1 | Title 2 | `
`|-----    |-----    | `
`| Text    | Text    | `

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

## Category Lists

You can include a list of all pages in a particular category (defined by the part of the page name before the ':').

`[[categorylist theme]]`

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

You can use includes like templates, creating consistent formatting easily across other wiki articles.  Within the original wiki page (the template), you style everything the way you want, but use placeholders like `%{foo}` where page-specific variables will go.  When you include that template inside another wiki page, set variables within the include statement like so:

`[[include PageName`
`|foo=Foo Value`
`]]`

In the page, `%{foo}` will be replaced with "Foo Value".  Be sure to put only one variable per line, and start the line with |.

## Table of Contents

You can include an auto-generated table of contents with level 2 and 3 headers.  (Level 1 is excluded because it's always the page title.)

`[[toc]]`

## Spans, Divs, and Pre-Formatted Blocks

Using the raw `<div></div>`, `<span></span>` and `<pre></pre>` block tags often doesn't work the way you want for a variety of technical reasons.  Instead you can use the div/span/pre wiki extensions.

`[[div class="someClass"]]`
`Some text`
`[[/div]]`

## Disabling Extensions

If you want to disable all custom Ares markdown extensions on a page, simply add text [[disableWikiExtensions]] anywhere on the page.  That's probably only necessary on a page like this where you're trying to explain the wiki extensions.

## Files

The Ares web portal has a central file repository.  This allows images to easily be used across multiple pages.   You can use folders to organize the images by page name or any other criteria.  Character gallery images will automatically be put into a folder matching the character name.

You can upload and view available files just by visiting the [File Repository](/files).  Click on any file to view or manage it.

> **Tip:** If you want to overwrite/replace an existing file, be sure the 'overwrite' checkbox is checked.

Once an image file is uploaded, you can use it on any page with:

`[[image folder\filename.jpg]]`  

You can also use it in your character profile as explained in .  If you upload something that is not an image, you can link to it like so:

`[Link Text](\folder\filename.jpg)`