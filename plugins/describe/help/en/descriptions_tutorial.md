---
toc: Locations and Descriptions
summary: Describing game objects.
tutorial: true
---

# Descriptions

Every character, room and exit has a description that tells you what your character sees when they look around.  You can also have multiple outfits for your character, and have more detailed views that are separate from your main description. 

> **Tip:** You can set a description on yourself and on any room that you own.  If you have the `desc_places` permission (typically given to builder characters), you can describe any room.   With the `desc_anything` permission, you can describe anything - characters or rooms.

[[toc]]

## Looking Around

The `look` command is used to look around. By default it looks at the description of the room you're in, but you can also look at other characters or details.  There'a also a `glance` command to take a quick glance at everything around you.

On the web portal, the room description will be part of the scene page.  You can also browse character and location descriptions through character profiles (typically under Directory -> Characters) and the location directory (typically under Directory -> Locations).

## Short Descs

Characters have a short description that shows up in things like the glance command and the character list in room descriptions.  You set this separately from your main desc.
  
> **Tip:** Exits can have a short description also, which is used in place of the destination name when listing exits in a room.

## Details

Details can be used to keep more detailed views separate from the main description.  You can use details on characters or rooms.

For example, if your character has a ring, you might create a really detailed description of that ring and put it in a "Ring" detail.  You could also do this for signs, notes, and other landmarks in rooms. 

> **Tip:** Details take the place of desc-placeholder objects that one might find in other MUSH servers.

## Outfits

The `outfit` command lets you manage multiple outfits for your character.  Typically you'll define one base outfit for your character's body description, and then have a variety of mix-and-match clothing outfits for your different clothes and accessories.  You can wear a combination of outfits using the `wear` command.  This will set your description to the selected outfits.

Here is an example of how the system can be used, given some pretty simplistic descs and a sample character Thomas. First we'd create a "wardrobe" for Thomas: 

* base - Thomas is a tall man with brown hair and eyes.
* casual - Today Tom is dressed casually, in blue jeans and a T-shirt. 
* suit - Tom is wearing a blue pin-stripe suit, with a tacky yellow tie.
* ring - He's wearing a wedding ring.

To set up Tom's description so he's wearing his suit and wedding ring, we could wear `base suit ring` and his combined description would be:

    Thomas is a tall man with brown hair and eyes. Tom is wearing a blue pin-stripe suit, with a tacky yellow tie. He's wearing a wedding ring.

If he's working in the garage, we might wear `base casual` and get:

    Thomas is a tall man with brown hair and eyes. Today Tom is dressed casually, in blue jeans and a T-shirt. 

## Vistas

Vistas allow you to have a catalog of room descriptions, much the same way that you can have multiple outfits for a character.  The base description is set via the `describe` command.  Then you have vistas that are added to that based on the time of day (morning, day, evening, night) and season (spring, summer, fall, winter).

All vistas are optional.  Think of them like building blocks.  If your room only has a 'night' vista and a 'summer' vista, then the description would be:

* On a summer night:  `[base desc] [night desc] [summer desc]`
* On a summer day:  `[base desc] [summer desc]`
* On a spring/fall/winter night:  `[base desc] [night desc]`
* Any other time:  `[base desc]`

> **Note:** The weather condition is also appended to the description if the weather system is enabled.

## Command Reference

[Description Commands](/help/descriptions)
[Look Commands](/help/look)
[Detail Commands](/help/details)
[Outfit Commands](/help/outfits)
[Vista Commands](/help/vistas)