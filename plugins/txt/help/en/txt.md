---
toc: Playing the Game
summary: How to send texts.
aliases:
- text
- Texting
- texts
---

## Texting from the Web-Portal
There is a "Send Txt" button on any active scene in the web-portal. Texting into a scene will send a message in-game, if the character is connected. Otherwise, it will just send a text into the scene.

`<name>=<message>` - Send a message to a person from the webportal. If the recipient isn't already a participant in the scene, this will add them.

> Keep in mind that someone who's not logged in won't know they've been texted in a scene unless they check! Be courteous!

## Commands
`txt <name> [<name> <name>]=<message>` - Send a message to name(s).
`txt <name> [<name> <name>]/<scene #>=<message>` - Send a text to name + log it in a scene. If the recipient isn't already a participant in the scene, this will add them.

`txt [=]<message>` - Send a message to your last text target + last scene.

`txt/reply` - See who last texted you.
`txt/reply <message>` - Reply to the last text (including all recipients + scene, if there is one)

`txt/newscene <name> [<name> <name>]=<message>` - Starts a new scene + sends a message to those names + the scene.

`txt/color <color>` - Color the (TXT to <name>) prefix. Use ansi color format for this, ex: \%xh\%xr for red highlight, \%xh\%xg for green highlight.

> If you do not wish to receive txts (in general, or from a specific person), the `page/ignore <name>=<on/off>` and `page/dnd <on/off>` commands will block txts as well.
