---
toc: ~admin~ Managing the Game
summary: Managing channels.
---
# Managing Channels

> **Permission Required:** These commands require the Admin role or the permission: manage\_channels

## Creating and Deleting Channels

Channel admins can create, edit and delete channels.  Go to [Admin -> Setup -> Setup Channels](/channels-manage). Channel properties include:

* Name - A unique name for the channel.
* Description - An optional description.
* Default Color - The default channel color, as an ansi code (e.g., \%xh\%xr). Players can set their own custom colors.
* Default Alias - A space-separated list of commands for talking on the channel (e.g., 'c ch cha' for the chat channel). If you don't specify this, the system will default to the first few letters of the channel.
* Join Roles - Players with this [role](/help/roles) can join the channel. Use 'everyone' to allow everybody to talk.
* Talk Roles - Players with this [role](/help/roles) can talk on the channel. Use 'everyone' to allow everybody to talk.

> **Note:** Take care to avoid ambiguous channel aliases (like 'g' if you have both a Galactica and Global channel) and aliases that overlap with other command (like 'n' for north or 'p' for page).  Remember that AresMUSH ignores prefixes like '+' on commands.

`channel/create <channel>`
`channel/delete <channel>`
`channel/rename <channel>=<new name>` - Be cautious renaming channels since peoples' aliases may no longer make sense.
`channel/clear <channel>` - Clears the recall history.
`channel/describe <channel>=<description>`
`channel/defaultcolor <channel>=<ansi prefix>` - Sets a channel's default color.
`channel/joinroles <channel>=<roles>` - Use commas to separate multiple roles.  Use "none" to clear existing roles.
`channel/talkroles <channel>=<roles>` - Use commas to separate multiple roles.  Use "none" to clear existing roles.
`channel/defaultalias <channel>=<aliases>` - Sets the default aliases for a channel.

## Adding and Removing Characters

Channel administrators can add or remove characters from a channel:

`channel/addchar <char>=<channel>`
`channel/removechar <char>=<channel>`