---
toc: 4 - Writing the Story
tutorial: true
summary: How to send texts.
---
# Texts

The text plugin lets you send text messages to other characters.

It is generally considered fine to start a text scene with someone without permission - as long as you recognize that they may not see or respond to texts in a timely fashion. Please don't take the length of time between texts to be IC; sometimes OOC factors delay someone's ability to respond.

[[toc]]

##Sending Texts without a Scene

On the game, you can text characters online by sending a text without specifying a scene number. These texts are not added to any scene and will not be logged or saved unless you do so manually.

Do `txt <name>=<message>` to send a text without adding it to a scene.

> **Note:** Texting characters without an attached scene only works when all characters are logged in to the game via telnet; it will not work via the portal. Texting via the portal requires a scene.

##Sending Texts in a Scene

###Starting a Scene

On game, you can start a new text scene in one easy step.

`txt/newscene <name> [<name}]=<message>`

This will start a new scene, set the location and scene type, emit the text to all characters currently online, and add the text to the scene.

On the portal, you will need to [start a scene](/help/scenes_tutorial#starting-a-scene) and set the location (Text) and type (Text) manually.

###Replying to Texts

####On Game
If someone sends you a text, you can quickly reply to the text using `txt/reply=<message>`. This will send your text to everyone in the recipient list and add it to the scene. To see who last texted you, type `txt/reply`

On the game, the 'txt' command will remember the last character and scene you texted. If you continue to text the same person, you can simply do `txt <message>`.

If you're texting several different recipients or to several different scenes at once, you'll need to specify who you are texting and what scene it should be added to by doing `txt <name> [<name}]/<scene>=<message>`.

If you text someone who was not previously in that scene, they will automatically be added to the scene.

####On the Portal
Texts sent from the portal add the texts to the scene and emit to anyone who is online on the game.

Send texts by using the 'Txt' button next to the 'Add OOC' and 'Add Pose' buttons on the portal. By default, this button texts everyone in the scene.

To send texts to a different recipient list, do `<name> [name]=<message>` and use the 'Txt' button.

##Text Settings

###Text Color

You can choose a personal text color to make text scenes more readable. Do `txt/color <color>` to set your personal color.  You can view available colors by doing `colors`, `colors1`, `colors2`, etc.

Use the full ansi color format for this, ex: \%xh\%xr for red highlight, \%xh\%x46 for bright green highlight, etc.

###Ignoring or Blocking Texts

If you do not wish to receive txts (in general, or from a specific person), the `page/ignore <name>=<on/off>` and `page/dnd <on/off>` commands will block txts as well.
