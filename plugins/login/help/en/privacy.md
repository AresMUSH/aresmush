---
toc: 1 - Getting Started
summary: Ares privacy practices.
title: Data and Privacy on Ares Games
tutorial: true
---
# Data and Privacy on Ares Games

It's up to each individual Ares game to determine their privacy policies.  Ideally this will be conveyed to players in the terms of service acknowledgement or a policy file on the wiki.  This article provides some **general** information about privacy on Ares games.

> Note: This article is about the Ares game server.  For AresCentral and aresmush.com privacy practices, see the [website privacy policy](http://aresmush.com/privacy.html).

**Ares has no built-in commands to support admins spying on players.**  That means there's no SUSPECT flag or DARK power for spying, and no admin commands to view private scenes, mail, or private messages.  Just as with any online service, though, **any** data transmitted to the server and/or stored in the database is ultimately accessible to the game owner and anyone they choose to share it with. They may install custom loggers or custom commands, or crack open the database manually. Sensitive information is best kept off-game.

## What Data Is Stored

Here are the types of personal data that can be stored by the game:

* The **IP Address** and hostname you're connecting from is saved every time you connect.
* Your **email address** and timezone is saved if you choose to provide it.
* Your Ares **player handle**, friends list and handle preferences are saved if you choose to link a character to your handle.
* **Conversations**--channel chat, private messages, poses and OOC chat (if scene logging is enabled) and mail messages--are all saved to the database and may contain personal information. (i.e. if you're chatting with your buddy about your family/job/hometown/etc.)

Permission controls limit who can see this data, described in "Who Can View Your Data" below. 

## How Data Is Stored

Your data can be stored in either the game's database, or debug log files on the server.

Conversations and passwords are **only** stored in the database, never in debug logs.

Neither the database nor the log files are encrypted.  Passwords are hashed.

## Who Can View Your Data

Debug logs and everything in the database is accessible to the game owner and players with coder privileges.  Beyond that, Ares commands limit who can view what.  But again we'll reiterate:

> Just as with any online service, **any** data transmitted to the server and/or stored in the database is ultimately accessible to the game owner and anyone they choose to share it with. Sensitive information is best kept off-game.

### Channels

Channel chat is visible both in a MU client and on the web portal to any player given access to that channel.  Since the game admins can change permissions at any time, you should generally assume that channel chats are NOT private.

Anyone on the channel may elect to report a channel conversation to the game admin in the case of harassment or abuse.

### Private Messages

Private messages are visible both in a MU client and on the web portal to players involved in the conversation.  If someone is added mid-conversation, a new conversation is started (i.e. the new person won't see what came before).  

Any party to the conversation may elect to report all or part of the conversation to the game admin in the case of harassment or abuse.  

There is no built-in command allowing game admins to view private message chats.

### Scenes

Scenes may be marked as 'open' or 'private'.  Open scenes are visible to everyone, both in a MU client and on the web portal.  Private scenes are visible only to those who have been invited.  If scene logging is enabled (which it is by default), the log will include all poses and OOC chat.

Any party to the scene may extend invitations, download the log, or share the log on the web portal when the scene is complete. In other words, don't assume a 'private' scene is going to _stay_ private.

Anyone in the scene may elect to report the scene log to the game admin in the case of harassment or abuse.

There is no built-in command allowing game admins to view or join private scenes.

### Mail

Mail messages are visible in a MU client and on the web portal to anyone CC'ed on the message.  Messages may be forwarded.

There is no built-in command allowing game admins to view other peoples' mail messages.

### Other Data

Your player handle is visible to all players.  There is no built-in command allowing admins to view your handle preferences, such as your friends list.

Email address, if set, is visible to game admins.

Your IP address is visible to game admins.

The Ares web portal sets a cookie to remember you when you log back in.

## How to Delete Your Data

Many games keep around character objects even after the player has left.  If you want your personal information deleted, you will need to contact the game admins to request it.

## How Data Is Transmitted

This is not really Ares-specific, but it's good to be aware of: If you're using a MU client, your connection is extremely insecure.  Data is transmitted from your PC to the game in plain text with no encryption, and could easily be intercepted.

Most Ares web portals will use HTTPS for security.  Those that don't are just as insecure as a MU client.