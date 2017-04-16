---
toc: Channels
summary: Talking on channels.
order: 2
---
# Talking on Channels

Each game will have a variety of channels.  You can see available channels and their descriptions using the `channels` command.  This also tells you at a glance what channels you've joined and what commands are used to talk on them, which we'll discuss in a moment.

`channels` - Lists channels and their descriptions

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

`channel/join <channel>`
`channel/leave <channel>`

## Channel Messages

When someone says something on a channel, you'll see the message prefixed by the channel name.

    <Chat> Faraday says, "Hello."

You can talk on a channel using the full channel name followed by the message.  For example: `chat hello`

`<channel name> <message>` - Talks on a channel.

## Channel Aliases

It's convenient to have shorter commands to talk on channels so you don't have to type out things like `questions Hi!`.  You can make *aliases* for channel names and then talk on the channel using the alias instead of the full name.  For example, if you set up an alias of 'ch' for the chat channel, you can then do `ch hello`.

`<channel alias> <message>` - Talks on a channel using the alias.

The system will set you up with some channel aliases by default, which you can see on the `channels` command list.  You can change your aliases at any time, and can even set multiple aliases for a single channel.

`channel/alias <channel>=<alias>` - Changes the alias.  You can use multiple aliases, separated by spaces.

You can also set the alias when you first join a channel.

`channel/join <channel>[=<alias>]`

> **Tip:** Take care to avoid channel aliases that overlap with other commands, like 'n' for north or 'p' for page.  Remember that AresMUSH ignores prefixes like '+' on commands.