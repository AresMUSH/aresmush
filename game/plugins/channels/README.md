Channels Plugin
====

The Channels plugin provides a game-wide chat system.  The Ares channels system does its best to support both PennMUSH and TinyMUX command syntax, so whether you like 'addcom' or '@chan/join', hopefully you'll find the commands familiar.

Channels will show your Handle, if it's public.

    <Chat> @Faraday (Fara) says, "Hello!"

The 'channels' command shows available channels and chat commands.

    +==~~~~~====~~~~====~~~~====~~~~=====~~~~=====~~~~====~~~~====~~~~====~~~~~==+
    Channel                       Description             Announce  Restricted To
    ------------------------------------------------------------------------------
    (+) Chat                      Public chat.               +      
    (+) Questions                 Game questions.            +      
    
    ------------------------------------------------------------------------------
    (+) indicates channels you are on:
         ch <message> talks on Chat.
         cha <message> talks on Chat.
         q <message> talks on Questions.
         qu <message> talks on Questions.
    +==~~~~~====~~~~====~~~~====~~~~=====~~~~=====~~~~====~~~~====~~~~====~~~~~==+

Like TinyMUX, you can define your own custom aliases for a channel.  You can change this at any time.  You can do 'addcom' to join a channel, and use commands like 'qu who' to see who's on the questions channel.

Like PennMUSH, the system will provide default channel aliases based on the first 2 and 3 letters of the channel name, as long as there are no conflicts with other channels.  You can use 'channel/join' to join a channel, and use commands like 'channel/who' to see who's on a channel.

The channels system ties in with the Roles plugin to restrict who is allowed to join certain channels.

Admins can configure channel colors and the channel bracket style (<> or []).