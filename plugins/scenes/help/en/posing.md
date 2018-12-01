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
- whisper
- mutter
- setpose
---
# Posing

**Posing** is the term for communication that happens between characters who occupy the same MUSH room.  This is the 'meat' of the game, the descriptions of character speech and actions that make up the story. There are several commands for posing, some of which add your character's name and other text to the message automatically as a convenience.

`say Hello!` or `"Hello!` - Bob says, "Hello!"
`pose waves.` or `:waves.` - Bob waves.
`;'s hair is black.` - Bob's hair is black.
`emit Go Bob!` or `\Go Bob!` - Go Bob!
`ooc I have a question.` or `'I have a question.` - <OOC> Bob says, "I have a question."

## Private Emits / Whispers

The `pemit` command lets you make a private emit only to certain characters.  This will appear like an emit, but with an OOC notice in front telling who it came from.

`pemit <list of names>=<message>` - Make a private emit.
  
You can also whisper to another character.  This is formatted like a 'say' (e.g. `whisper Cate=Hi!` - Bob whispers to Cate, "Hi!") but is only shown to the recipient.  The room doesn't see anything.

`whisper <name>=<message>` - Whisper to someone.

## Set Pose

Storytellers can mark an emit as a set pose.  It will be set off with a border on the game, and highlighted in scene and wiki logs.

`emit/set <set pose>`

## Nospoof

Emit poses are normally anonymous to maintain the flow of the RP text.  If someone is abusing this privilege, you can turn on your "nospoof" setting to identify emits and report the offender to the admin.

`nospoof <on or off>`
