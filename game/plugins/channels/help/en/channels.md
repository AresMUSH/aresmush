---
toc: Communicating
summary: Using the public chat channels.
aliases:
- chat
- comsys
---
# Channels

Channels are public forums for out-of-character communication.  Each game will have a variety of channels available for use.  Some will be locked so that only people with certain roles may use them.

## Finding Channels

You can see available channels and their descriptions using the `channels` command.  This also tells you at a glance what channels you've joined and what commands are used to talk on them, which we'll discuss in a moment.

[[help channels]]

    +==~~~~~====~~~~====~~~~====~~~~=====~~~~=====~~~~====~~~~====~~~~====~~~~~==+
    Channel                       Description             Announce  Restricted To
    ------------------------------------------------------------------------------
    (+) Chat                      Public chit-chat           +      
    (+) Questions                 Questions and answers.     +   
    (-) Admin                     Admin discussions.         -   
    ------------------------------------------------------------------------------
    (+) = channel on     (X) = channel muted     (-) = channel off
    
    You can use c <msg> or ch <msg> or cha <msg> to talk on the Chat channel. 
    You can use q <msg> or qu <msg> or que <msg> to talk on the Questions channel. 
    +==~~~~~====~~~~====~~~~====~~~~=====~~~~=====~~~~====~~~~====~~~~====~~~~~==+

Some channels are restricted.  You can only use them if you have one of the roles listed in the 'Restricted To' column.

## Joining and Leaving Channels

You will only see messages on channels you join, and you may leave those channels at any time. 

[[help channel/join]]
[[help channel/leave]]

> **Tip:** AresMUSH also supports the MUX-style channel commands, so you can use the keywords "on", "off", "who", "last", "mute", and "unmute" with the channel alias.  For example:  `pub who`.

## Channel Messages

When someone says something on a channel, you'll see the message prefixed by the channel name.

    <Chat> Faraday says, "Hello."

## Talking on Channels

You can talk on a channel using the full channel name followed by the message.  For example: `chat hello`

[[help channel/talk]]

## Channel Aliases

It's convenient to have shorter commands to talk on channels so you don't have to type out things like `questions Hi!`.  You can make *aliases* for channel names and then talk on the channel using the alias instead of the full name.  For example, if you set up an alias of 'ch' for the chat channel, you can then do `ch hello`.

The system will set you up with some channel aliases by default, which you can see on the `channels` command list.  You can change your aliases at any time, and can even set multiple aliases for a single channel.

[[help channel/alias]]

You can also set the alias when you first join a channel.

[[help channel/join]]

> **Tip:** Take care to avoid channel aliases that overlap with other commands, like 'n' for north or 'p' for page.  Remember that AresMUSH ignores prefixes like '+' on commands.

## Titles

You can configure an optional title to appear in front of your name when you talk on a channel.  Titles are channel-specific.

    <Chat> Captain Faraday says, "Hello."

[[help channel/title]]

## Mute

Channels sometimes get spammy, or distract you when you're RPing.  You can temporarily mute a channel without actually leaving it.  Mute is cleared when you disconnect.  You can use 'all' for the channel name to mute/unmute all channels at once.

[[help channel/mute]]

> Note:  'Mute' is the gagging feature on AresMUSH.  For the MUX version that mutes only connection messages, use the 'channel/announce' command.

## Who List

You can see who's on a channel, and whether they're currently listening or muted.

[[help channel/who]]

## Connection Announcements

By default, the game will show you who has connected and disconnected from a channel, so you can greet people and stop having a conversation with someone who is no longer there.  If you don't want to see those messages, you can turn them on or off for a particular channel.

[[help channel/announce]]

## Recall

Channels save a history of the last twenty-five messages.  You can review them using the recall command.  Specifying the number of messages to review is optional.

[[help channel/recall]]