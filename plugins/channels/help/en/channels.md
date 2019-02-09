---
toc: 2 - Communicating
summary: Using the public chat channels.
aliases:
- chat
- comsys
---
# Channels
Channels are public forums for out-of-character communication.

`channels` - Lists channels and their descriptions
**Tip:** Some channels are restricted.  You can only use them if you have one of the roles listed in the 'Restricted To' column.

`channel/join <channel>[=<alias>]` - Joins a channel.
`channel/leave <channel>` - Leaves a channel.
**Tip:** AresMUSH also supports the MUX-style channel commands, so you can use the keywords "on", "off", "who", "last", "mute", and "unmute" with the channel alias.  For example:  `pub who`.

## Talking & Reading on Channels
`<channel name> <message>` - Talks on a channel.
`<channel alias> <message>` - Talks on a channel using the alias.
`channel/alias <channel>=<alias>` - Changes the alias.  You can use multiple aliases, separated by spaces.
**Tip:** The system will set you up with some channel aliases by default, which you can see on the `channels` command list.

`channel/mute <channel>` - Silences a channel temporarily.
`channel/unmute <channel>` - Un-silences a channel.
`channel/recall <channel>[=<num messages>]` - Shows the last few messages on a channel.

## Who List & Announcements
`channel/who <channel>` - Shows who's on the channel
`channel/announce <channel>=<on/off>` - Turns connection messages on or off.

## Recall

`channel/recall <channel>[=<num messages>]` - Shows the last few messages on a channel.

## Reporting Abuse
`channel/report <channel>=<explanation>`
