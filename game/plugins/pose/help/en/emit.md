---
toc: Scenes
summary: Emitting messages.
aliases:
- nospoof
- emit
- pemit
- whisper
- mutter
- setpose
---
# Emits

Emits allow you to send messages to the room you're in.  There are several commands to emit, some of which add your character's name and other text to the message automatically as a convenience.

`say Hello!` or `"Hello!` - Bob says, "Hello!"
`pose waves.` or `:waves.` - Bob waves.
`;'s hair is black.` - Bob's hair is black.
`emit Go Bob!` or `\Go Bob!` - Go Bob!
`ooc I have a question.` or `'I have a question.` - <OOC> Bob says, "I have a question."

## Private Emits / Whispers

The `pemit` command lets you make a private emit only to certain characters.

`pemit <list of names>=<message>`

## Set Pose

Storytellers can mark an emit as a set pose.  It will be set off with a border on the game, and highlighted in scene and wiki logs.

`emit/set <set pose>`

## Nospoof

Emit poses are normally anonymous to maintain the flow of the RP text.  If someone is abusing this privilege, you can turn on your "nospoof" setting to identify emits and report the offender to the admin.

`nospoof <on or off>`
