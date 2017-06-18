---
toc: Channels
summary: Advanced channel commands.
---
# Channel Utilities

Beyond the basic commands used to join channels and chat, there are a variety of other things you can do with channels.

> **Tip:** AresMUSH also supports the MUX-style channel commands, so you can use the keywords "on", "off", "who", "last", "mute", and "unmute" with the channel alias.  For example:  `pub who`.

## Titles

You can configure an optional title to appear in front of your name when you talk on a channel.  Titles are channel-specific.

`channel/title <channel>=<title>`.

    <Chat> Captain Faraday says, "Hello."

## Mute

Channels sometimes get spammy, or distract you when you're RPing.  You can temporarily mute a channel without actually leaving it.  Mute is cleared when you disconnect.  You can use 'all' for the channel name to mute/unmute all channels at once.

`channel/mute <channel>`
`channel/unmute <channel>`

> Note:  'Mute' is the gagging feature on AresMUSH.  For the MUX version that mutes only connection messages, use the 'channel/announce' command.

## Who List

You can see who's on a channel, and whether they're currently listening or muted.

`channel/who <channel>` - Shows who's on the channel

## Connection Announcements

By default, the game will show you who has connected and disconnected from a channel, so you can greet people and stop having a conversation with someone who is no longer there.  If you don't want to see those messages, you can turn them on or off for a particular channel.

`channel/announce <channel>=<on/off>`

## Recall

Channels save a history of the last twenty-five messages.  You can review them using the recall command.  Specifying the number of messages to review is optional.

`channel/recall <channel>[=<num messages>]` - Shows the last few messages on a channel.