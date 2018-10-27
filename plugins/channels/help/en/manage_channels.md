---
toc: ~admin~ Managing the Game
summary: Managing channels.
---
# Managing Channels
**These commands require the Admin role or the permission: manage\_channels**

## Adding and Removing Characters

Channel administrators can add or remove characters from a channel:

`channel/addchar <char>=<channel>`
`channel/removechar <char>=<channel>`

## Creating and Deleting Channels
`channel/create <channel>`
`channel/delete <channel>`

## Channel Appearance
`channel/describe <channel>=<description>`
`channel/color <channel>=<ansi prefix>` - Sets a channel's color.

**Tip:** Use full ansi code(s) not just the color name: \%xc  You can use multiple codes: \%xh\%xr

## Roles
Control who is allowed to use a channel. If you change the roles for an existing channel, anyone who no longer has permission will automatically leave the channel.

`channel/roles <channel>=<roles>` - Use commas to separate multiple roles.  Use "none" to clear existing roles.

## Default Aliases
The game automatically uses the first letters of the channel name for its default aliases.  You can specify a list of space-separated names: 'c ch cha' for the chat channel.

`channel/defaultalias <channel>=<aliases>` - Sets the default aliases for a channel.

**Tip:** Avoid ambiguous channel aliases (like 'g' if you have both a Galactica and Global channel) and aliases that overlap with other command (like 'n' for north or 'p' for page).  Remember that AresMUSH ignores prefixes like '+' on commands.
