---
toc: ~admin~ Managing the Game
summary: Managing player login info.
aliases:
- newpassword
---
# Managing Login Information

> **Permission Required:** These commands require the Admin role or the permission: manage\_login

Admins and people with the appropriate permissions can manage another character's login information

## Resetting a Password

You can reset someone's password if they've forgotten it.  It will choose a random new password and tell it to you.

`password/reset <name>`

## Changing Names and Aliases

You can rename a player or change their alias.

`name <old name>=<new name>`
`alias <name>=<alias>` (leave alias blank to clear it)

## Viewing Email

You can also view someone's email.

`email <name>`

## Changing Terms of Service

You can change the terms of service in the configuration section of the game's web portal.  When you make substantial changes, you may want to require everyone to re-acknowledge the TOS.  You can reset all prior acknowledgements.

`tos/reset` - Resets the terms of service acknowledgements.
