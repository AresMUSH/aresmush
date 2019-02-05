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

You can set a description on yourself and on any room that you own.  

`describe <name>=<description>` - Describes something

If your client supports the [Edit Feature](/help/edit), you can use the edit command to grab the existing description into your client's input buffer.

`describe/edit <name>` - Grabs the existing description into your input buffer.

## Describe Permissions

If you have the `desc_places` permission (typically given to builder characters), you can describe any room, even if you don't own it.   With the `desc_anything` permission, you can describe anything - characters or rooms.

## Short Description

Characters have a short description that shows up in things like the glance command and the character list in room descriptions.  You set this separately from your main desc.

`shortdesc <name>=<description>` - Sets your short desc.
`shortdesc/edit <name>` - Grabs an existing short desc into your input buffer.
  
> Note: Exits can have a short description also, which is used in place of the destination name when listing exits in a room.

## Outfits and Details

You can store multiple descriptions with the [Outfits](/help/outfits) commands, and have expanded [Details](/help/details) (like jewelry or tatoos).