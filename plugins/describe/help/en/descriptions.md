---
toc: Looking at Things
summary: Setting descriptions.
order: 2
aliases:
- describe
- shortdesc
- desc
---
# Descriptions

Every character, room and exit has a description that tells you what your character sees when they look around.  You can also have multiple outfits for your character, and have more detailed views that are separate from your main description.

## Setting Descriptions

`describe <name>=<description>` - Describes something
`shortdesc <name>=<description>` - Sets your short desc.
`shortdesc/edit <name>` - Grabs an existing short desc into your input buffer.

You can store multiple descriptions with the [Outfits](/help/outfits) commands, and have expanded [Details](/help/details) (like jewelry or tatoos).

`describe/edit <name>` - Grabs the existing description into your input buffer.

## Describe Permissions

If you have the `desc_places` permission (typically given to builder characters), you can describe any room, even if you don't own it.   With the `desc_anything` permission, you can describe anything - characters or rooms.
