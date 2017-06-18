---
toc: Descriptions
summary: Setting descriptions.
aliases:
- describe
- shortdesc
---
# Setting Descriptions

You can set a description on yourself and on any room that you own.  

`describe <name>=<description>` - Describes something

If your client supports the [Edit Feature](/help/utils/edit), you can use the edit command to grab the existing description into your client's input buffer.

`describe/edit <name>` - Grabs the existing description into your input buffer

## Describe Permissions

If you have the `desc_places` permission (typically given to builder characters), you can describe any room, even if you don't own it.   With the `desc_anything` permission, you can describe anything - characters or rooms.

## Short Description

Characters have a short description that shows up in things like the glance command and the character list in room descriptions.  You set this separately from your main desc, and can also use the edit feature if your client supports it.

`shortdesc <name>=<description>`
`shortdesc/edit <name>`

## Outfits and Details

You can store multiple descriptions with the [Outfits](/help/describe/outfits) commands, and have expanded [Details](/help/describe/details) (like jewelry or tatoos).