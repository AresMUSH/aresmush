---
toc: Community
tutorial: true
summary: Using the game wiki.
aliases:
- files
- templates
---

# Wiki

Part of the web portal is the game's wiki, an information repository typically used for theme and policy files. The wiki is typically found under the "Wiki" menu on the web portal.

## Creating and Editing Pages

Any approved player can contribute to the wiki.  The 'Edit' button will appear at the bottom of any page you can edit.  You can also use the 'Create New Page' menu item to make a new one. 

Changes will appear in the 'Recent Changes' page, which admins can use for review or moderation purposes.

## Markdown

Wiki pages use [markdown formatting](/help/markdown), with various "extensions" available for MUSH-specific things like dynamic character or scene lists.

## Content Tags

Wiki pages, along with many other kinds of data, can have content tags to help categorize them.  See [Tags](/help/tags) for more info.

## Viewing History and Source

The 'Source/History' button at the bottom of a wiki page will show you a list of changes to that page.  You can see the page source (the text and formatting codes) of any version, and compare it the prior version.

## Templates

Templates are basically starter text for a blank wiki page, so you can prompt players to fill in the necessary fields.  You can create templates for wiki pages by naming the page `template:<name>`.  When someone creates a new wiki page, they can choose a template from the "template" drop-down.

For example, if your game puts IC "After Action Reports" on the wiki, you might create `template:aar` with contents like:

```
**Date:**  (the date of the incident)
**Participants:** (Who participated in the incident)
etc.
```

> **Note:** Updating a template does not affect existing pages; it just gives different starter text the next time someone tries to use that template.

## Includes

Includes let you define a component in one place and re-use it across many other pages.  Typically you'll use them for a fancy component, like a creature box that appears on the side of some explanatory text.  Like templates, they allow you to standardize your wiki formatting.

![Include Screenshot](https://aresmush.com/images/help-images/include.png)
(Image courtesy of Blu&Roadspike@AresCentral)

To define an include, just make a wiki page as normal (like a page named 'creature_box').  Within that wiki page, define your text and styling.  Use placeholders like `%{name}` where page-specific variables will go.  When you include that template inside another wiki page, set variables within the include statement like so:

```
[[include CreatureBox
|name=Wendigo
]]
```

In the page, `%{name}` will be replaced with "Wendigo".  Be sure to put only one variable per line, and start the line with |.

> **Tip:** If the page you're including has an actual % in it, you'll need to format it as two percents (%%) otherwise the variable processing will get confused.

You can use templates and includes together, by creating a template that prompts the player how to use an include.

> **Tip:** Unlike templates, updating an include updates the contents everywhere it's used.  

## Files

The Ares web portal has a central file repository.  This allows images to easily be used across multiple pages, including the wiki.   You can use folders to organize the images by page name or any other criteria.  Character gallery images will automatically be put into a folder matching the character name.

You can upload and view available files just by visiting the [File Repository](/files).  Click on any file to view or manage it.

> **Tip:** If you want to overwrite/replace an existing file, be sure the 'overwrite' checkbox is checked.

Once an image file is uploaded, you can use it on any page with:

`[[image folder\filename.jpg]]`  

If you place the image in a folder matching your character name, you can use it in the character profile image gallery. 

Only admins can upload non-image files.  If you do, you can link to them like so:

`[Link Text](\folder\filename.ext)`

----
This article has disabled wiki extensions: [[disableWikiExtensions]]