---
toc: ~admin~ Managing the Game
summary: Managing channels.
---
# Managing Channels

> **Permission Required:** These commands require the Admin role or the permission: manage\_channels

## Adding and Removing Characters

Channel administrators can add or remove characters from a channel:

`channel/addchar <char>=<channel>`
`channel/removechar <char>=<channel>`

## Creating and Deleting Channels

If you have the appropriate permissions, you can create and delete channels.

`channel/create <channel>`
`channel/delete <channel>`

## Channel Appearance

You can set a description for the channel (which will appear in the channels list) and the color used for its name.

`channel/describe <channel>=<description>`
`channel/color <channel>=<ansi prefix>` - Sets a channel's color.

> **Tip:** Use full ansi code(s) not just the color name.  For example: \%xc  You can use multiple codes.  For example:  \%xh\%xr

## Roles

You can control who is allowed to use a channel by assigning roles to it.  Only people with one of the specified roles will be allowed to join or talk on the channel. 

If you change the roles for an existing channel, anyone who no longer has permission to be there will automatically leave the channel.

`channel/roles <channel>=<roles>` - Use commas to separate multiple roles.  Use "none" to clear existing roles.

## Default Aliases

The system will automatically use the first couple letters of the channel name for its default aliases (if the player doesn't specify their own).  You can change this by specifying a list of space-separated names.  For example: 'c ch cha' for the chat channel.

`channel/defaultalias <channel>=<aliases>` - Sets the default aliases for a channel.

> **Tip:** Take care to avoid ambiguous channel aliases (like 'g' if you have both a Galactica and Global channel) and aliases that overlap with other command (like 'n' for north or 'p' for page).  Remember that AresMUSH ignores prefixes like '+' on commands.