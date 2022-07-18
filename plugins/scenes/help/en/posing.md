---
toc: 4 - Writing the Story
summary: Writing your character's actions.
order: 1
aliases:
- say
- nospoof
- pose
- emit
- setpose
- pemit
- whisper
---
# Posing

**Posing** is the term for communication that happens between characters who occupy the same MUSH room.  This is the 'meat' of the game, the descriptions of character speech and actions that make up the story. There are several commands for posing, some of which add your character's name and other text to the message automatically as a convenience.

`say Hello!` or `"Hello!` - Bob says, "Hello!"
`pose waves.` or `:waves.` - Bob waves.
`;'s hair is black.` - Bob's hair is black.
`emit Go Bob!` or `\Go Bob!` or `\\Go Bob!` - Go Bob!
`ooc I have a question.` or `'I have a question.` - <OOC> Bob says, "I have a question."
`nospoof <on or off>` - Identifies emits with the character name.

## Special Scene Emits

A GM emit is highlighted to ensure they aren't missed.  A scene set is similarly highlighted, and also sets a temporary addendum to the room description for the duration of the scene.

`emit/gm <gm pose>` - Emits a highlighted GM pose.
`emit/set <set pose>` - Emits a highlighted GM pose that also sets a temporary description in the room.

## Private Emits

Private emits (like the old whisper/@pemit commands from Penn and TinyMUX) are incompatible with the Ares web portal integration and scene system, and have been deprecated.