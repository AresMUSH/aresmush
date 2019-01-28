---
toc: ~admin~ Managing the Game
summary: Managing player login info.
aliases:
- newpassword
- pcreate
---
# Managing Login Information

> **These commands require the Admin role or the permission: manage\_login**

`password/reset <name>` - Will choose a random new password and tell it to you.

## Changing Names and Aliases

`name <old name>=<new name>`
`alias <name>=<alias>` (leave alias blank to clear it)

## Reserving a Character

If your game requires special steps before someone can get a character, you may have disabled character creation from the login screen.  In that case, you'll need a way to reserve characters for other people.  The `create/reserve` option creates a character and sets a temporary password.

`create/reserve <name>`

## Viewing Email

`email <name>`

## Changing Terms of Service

You can change the terms of service in the configuration section of the game's web portal.  When you make substantial changes, you may want to require everyone to re-acknowledge the TOS.  You can reset all prior acknowledgements.

`tos/reset` - Resets the terms of service acknowledgements.

## Setting the Message of the Day

You can set whether an important message appears on the notices screen (a 'message of the day').

`notice/motd <message>` - Sets the message of the day.  Leave blank to clear it.
