---
toc: 2 - Communicating
summary: Using the public chat channels.
aliases:
- chat
- comsys
---
# Channels

Channels are public forums for out-of-character communication.  Each game will have a variety of channels available for use.  Some will be locked so that only people with certain roles may use them.

## Finding Channels

You can see available channels and their descriptions using the `channels` command.  This also tells you at a glance what channels you've joined and what commands are used to talk on them, which we'll discuss in a moment.

`channels` - Lists channels and their descriptions

Some channels are restricted.  You can only use them if you have one of the roles listed in the 'Restricted To' column.

## Joining and Leaving Channels

You will only see messages on channels you join, and you may leave those channels at any time. 

`channel/join <channel>[=<alias>]` - Joins a channel.
`channel/leave <channel>` - Leaves a channel.

> **Tip:** AresMUSH also supports the MUX-style channel commands, so you can use the keywords "on", "off", "who", "last", "mute", and "unmute" with the channel alias.  For example:  `pub who`.

## Channel Messages

When someone says something on a channel, you'll see the message prefixed by the channel name.

    <Chat> Faraday says, "Hello."

## Talking on Channels

You can talk on a channel using the full channel name followed by the message.  For example: `chat hello`

`<channel name> <message>` - Talks on a channel.

## Channel Aliases

It's convenient to have shorter commands to talk on channels so you don't have to type out things like `questions Hi!`.  You can make *aliases* for channel names and then talk on the channel using the alias instead of the full name.  For example, if you set up an alias of 'ch' for the chat channel, you can then do `ch hello`.

The system will set you up with some channel aliases by default, which you can see on the `channels` command list.  You can change your aliases at any time, and can even set multiple aliases for a single channel.

`<channel alias> <message>` - Talks on a channel using the alias.
`channel/alias <channel>=<alias>` - Changes the alias.  You can use multiple aliases, separated by spaces.

You can also set the alias when you first join a channel.

`channel/join <channel>[=<alias>]`

> **Tip:** Take care to avoid channel aliases that overlap with other commands, like 'n' for north or 'p' for page.  Remember that AresMUSH ignores prefixes like '+' on commands.

## Titles

You can configure an optional title to appear in front of your name when you talk on a channel.  Titles are channel-specific.

    <Chat> Captain Faraday says, "Hello."

`channel/title <channel>=<title>`.

If you don't like seeing other peoples' channel titles, you can turn them off on a per-channel basis.  This only works in your main MU client output, and doesn't affect the 'Chat' tab on the web portal or channel recall.

`channel/showtitles <channel>=<on or off>`

## Mute

Channels sometimes get spammy, or distract you when you're RPing.  You can temporarily mute a channel without actually leaving it.  Mute is cleared when you disconnect.  You can use 'all' for the channel name to mute/unmute all channels at once.

`channel/mute <channel>` - Silences a channel temporarily.
`channel/unmute <channel>` - Un-silences a channel.

> Note:  'Mute' is the gagging feature on AresMUSH.  For the MUX version that mutes only connection messages, use the 'channel/announce' command.

## Who List

You can see who's on a channel, and whether they're currently listening or muted.

`channel/who <channel>` - Shows who's on the channel

## Connection Announcements

By default, the game will show you who has connected and disconnected from a channel, so you can greet people and stop having a conversation with someone who is no longer there.  If you don't want to see those messages, you can turn them on or off for a particular channel.

`channel/announce <channel>=<on/off>` - Turns connection messages on or off.

## Recall

Channels save a history of the last twenty-five messages.  You can review them using the recall command.  Specifying the number of messages to review is optional.

`channel/recall <channel>[=<num messages>]` - Shows the last few messages on a channel.

## Reporting Abuse

If someone is behaving badly on channel, you can bring it to the game admin's attention - along with an automatic, verified log of the channel recall buffer.  

`channel/report <channel>=<explanation>`