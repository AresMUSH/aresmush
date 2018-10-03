---
toc: ~admin~ Managing the Game
summary: Managing player login info.
aliases:
- newpassword
---
# Managing Login Information

> **These commands require the Admin role or the permission: manage\_login**

`password/reset <name>` - Will choose a random new password and tell it to you.

## Changing Names and Aliases

`name <old name>=<new name>`
`alias <name>=<alias>` (leave alias blank to clear it)

## Viewing Email

`email <name>`

## Changing Terms of Service

You can change the terms of service in the configuration section of the game's web portal.  When you make substantial changes, you may want to require everyone to re-acknowledge the TOS.  You can reset all prior acknowledgements.

`tos/reset` - Resets the terms of service acknowledgements.
