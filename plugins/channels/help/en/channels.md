---
toc: 2 - Communicating
summary: Using the public chat channels.
aliases:
- chat
- comsys
- comtitle
---
# Channel Commands

Channels are like chatrooms, letting you communicate with other players about specific topics (questions, general chit-chat, group-related messages, etc.)

> Get an overview of the chat channel system in the [Chat Tutorial](/help/chat_tutorial).

## Listing and Joining Channels

`channels` - Lists channels and their descriptions.
`channel/info <name>` - Shows detailed info for a channel.
`channel/join <channel>[=<alias>]` - Joins a channel.
`channel/leave <channel>` - Leaves a channel.
`channel/who <channel>` - Shows who's on the channel.

> **Tip:** AresMUSH also supports the MUX-style channel commands, so you can use the keywords "on", "off", "who", "last", "mute", and "unmute" with the channel alias.  For example:  `ch who`.

## Talking on Channels

You can talk on a channel using the full channel name followed by the message.  For example: `chat hello`.  You can also create **aliases** for channels so you can use shorter names.  For example, `ch hello`.

`<channel name or alias> <message>` - Talks on a channel.
`channels` - Views your current channel aliases.
`channel/alias <channel>=<alias>` - Changes the alias.  You can use multiple aliases, separated by spaces.
`channel/recall <channel>[=<num messages>]` - Shows the last few messages on a channel.

> **Tip:** Take care to avoid channel aliases that overlap with other commands, like 'n' for north or 'p' for page.  Remember that AresMUSH ignores prefixes like '+' on commands.

## Channel Options

`channel/mute <channel>` - Silences a channel until your next login.  Use 'all' to mute all channels at once.
`channel/unmute <channel>` - Un-silences a channel. Use 'all' to unmute all channels at once.
`channel/announce <channel>=<on/off>` - Turns connection messages on or off.
`channel/title <channel>=<title>` - Sets a channel-specific title to show up in front of your name.
`channel/showtitles <channel>=<on or off>` - Enables or disables other peoples' channel titles. (Only works when on a MU Client; web portal channels always show titles.)
`channel/color <channel>=<ansi prefix>` - Sets a channel's display color. Use full ansi code(s) not just the color name.  For example: \%xc  You can use multiple codes.  For example:  \%xh\%xr

## Reporting Abuse

If someone is behaving badly on channel, you can bring it to the game admin's attention - along with an automatic, verified log of the channel recall buffer.  

`channel/report <channel>=<explanation>`