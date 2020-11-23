---
toc: 4 - Writing the Story
summary: How to send texts.
aliases:
- text
- Texting
- texts
---
#Texts
Send text messages to other characters.

> Learn how the text system works in the [Text Tutorial](/help/txt_tutorial).

## Texting from the Web-Portal
There is a "Txt" button on any active scene in the web-portal. Texting into a scene will send a message in-game, if the character is connected. By default, texting on the portal will send a text to all participants of the scene.

`<name>=<message>` - Send a message to a specific person from the webportal. Adds recipients to scene if not already a participant.

>  **Note:** Someone who's not logged in may not know they've been texted unless they notice their notifications!

## Commands
`txt/newscene <name> [<name> <name>]=<message>` - Starts a new scene + sends a message to those names + the scene.

`txt <name> [<name> <name>]=<message>` - Send a message to name(s) outside of a scene.
`txt <name> [<name> <name>]/<scene #>=<message>` - Send a text to name + add it to a scene. Adds recipients to scene if not already a participant.
`txt [=]<message>` - Send a message to your last text target + last scene.

`txt/reply` - See who last texted you.
`txt/reply <message>` - Reply to the last text (including all recipients + scene, if there is one)

`txt/color <color>` - Color the (TXT to <name>) prefix. Use ansi color format for this, ex: \%xh\%xr for red highlight, \%xh\%xg for green highlight.

>  **Note:** If you do not wish to receive txts (in general, or from a specific person), the `page/ignore <name>=<on/off>` and `page/dnd <on/off>` commands will block txts as well.
