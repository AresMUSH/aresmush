AresMUSH
========

AresMUSH is a brand new MUSH server in development.  

What's a MUSH server?
=====================
MUSHes are a kind of text-based online gaming.  They are a rather unique mix of tabletop roleplaying games, creative writing, and improvisational acting.  For more information see:  [MUSHing 101](http://www.aresmush.com/mushing-101).

Why AresMUSH?
===============================
The premiere MUSH servers in existence, such as PennMUSH and TinyMUX, work really well but have two big barriers to entry:  First, you essentially need to be a programmer to set one up.  MUSH players come from all walks of life, and often the people who have really great creative ideas for a game are stymied by their lack of coding expertise. 

Second, the existing MUSH servers are deeply entrenched in their 1980's roots, with interfaces that just don't resonate with modern audiences.  (For example:  Having the profile command named "+finger" was intuitive when people were used to the Unix finger command.  Nowadays?  It just gets puzzled looks.)  Folks who have been MUSHing for a long time accept the status quo, but these counter-intuitive interfaces prove a barrier to entry.

The driving goal behind AresMUSH is to reduce these barriers of entry, to get more games out there and more people playing them.

For more information see:  [http://www.aresmush.com](http://www.aresmush.com/aresmush)

How's it Going?
===============================
So far so good.  

* Server up and running -- DONE
* Dynamic plugin framework -- DONE
* Localization framework -- DONE
* Database layer -- DONE
* Events system -- DONE
* Template system for customizing commands -- DONE
* Basic char create and connect commands -- DONE
* Rooms system -- IN PROGRESS

Take it for a Spin?
===============================

# One Time Setup

* Get latest code.
* Make sure you have the necessary modules (listed in the gemspec, even though it's not a gem yet!)
	> bundle install
* Edit the configuration files in game/config.
* Execute the Mongo database setup shown below.

# Mongo Setup

If you're going to run mongo locally a few things need to be done to prepare, the steps below handle the appropriate
bootstrapping.

1. Ensure that the passwords in game/config/database.yml are what you want to use.
2. Run 'rake db:local:bootstrap' to setup the database authentication
3. Run 'rake db:local:start' to start the database.
4. Run 'rake install' to install the default data.

Your database is now ready to go.

# Starting the Server #

* Run 'rake db:local:start' to start the database.
* Run 'rake start' to start the server.

# Stopping the Server #

* Either control-c / control-break the server or send it the kill signal
 *  TODO: add a shutdown command inside the system and a 'rake stop' command
* Run 'rake db:local:stop' to stop the database.

# Playing

* Telnet to the server/port you specified in server.yml
* Type 'create YourName YourPassword' to create a character.
* Type 'quit' to quit.
* Connect again, and type 'connect YourName YourPassword' to connect back to your character.
