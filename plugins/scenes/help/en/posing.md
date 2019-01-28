---
toc: Scenes
summary: Describing your actions.
order: 1
aliases:
- say
- nospoof
- pose
- emit
- pemit
- setpose
---
# Posing

**Posing** is the term for communication that happens between characters who occupy the same MUSH room.  This is the 'meat' of the game, the descriptions of character speech and actions that make up the story. There are several commands for posing, some of which add your character's name and other text to the message automatically as a convenience.

`say Hello!` or `"Hello!` - Bob says, "Hello!"
`pose waves.` or `:waves.` - Bob waves.
`;'s hair is black.` - Bob's hair is black.
`emit Go Bob!` or `\Go Bob!` - Go Bob!
`ooc I have a question.` or `'I have a question.` - <OOC> Bob says, "I have a question."

`pemit <list of names>=<message>` - Make a private emit with an OOC notice in front telling who it came from.
`emit/set <set pose>` - Mark an emit as a set pose that will be highlighted in scene and logs and stickied to the top of the scene.
`emit/gm <gm pose>` - Mark an emit as a GM pose that will be highlighted in scene and logs.

## Nospoof

Emit poses are normally anonymous to maintain the flow of the RP text.  If someone is abusing this privilege, you can turn on your "nospoof" setting to identify emits and report the offender to the admin.

`nospoof <on or off>`
