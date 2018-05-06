---
toc: 1 - Getting Started
summary: Learn about the help system.
order: 2
---
# Help System

The MUSH help system is here to help you learn how to use the in-game commands.  

## Finding Help Topics

The best way to read the help files is on the game's [Web Portal](/help).  Type `website` in your client to get the web address if you don't already have it.

You can also view help in-game using the `help` command.  

`help, help2, help3, etc.` - Shows each page of help topics.

## Help Quick Reference

If you already know the command name and just can't remember the syntax, the `quickref` command (aliased to qr) can look it up without spamming you with the full help file.

`quickref <command name>` - Views quick command syntax.

## Help Syntax

Help files will tell you what commands to type in the client.  Most commands take values, called **arguments**.

Command arguments appear in angle-brackets like `<command name>`.   So if a command tells you `page <recipient>=<message>` then the actual command you'd type would be something like `page Faraday=Hi there!`  

Sometimes arguments are optional.  Optional arguments are indicated with square brackets.  So if a command tells you `channel/join <channel>[=<alias>]` then the alias is optional.

Many commands use the slash character for different sub-commands.  For example:  `channel/join`, `channel/leave`, `channel/who`, etc.  These are called command **switches**.

## Multi-Page Commands

Many commands, including help, show a "page x of y" message at the bottom of the command text.  You can use a number after the command name to see each page - e.g., help, help2, help3, etc.  This works with commands that have switches too, so you can do requests2/all.

## Detailed Help Files

You can specify the help topic name to see detailed help for a topic or command.  If you're not sure of the name, partial matches and keywords will often work too.

`help <topic name>` - Searches the help and shows the full help text.

## Help Links

If you're viewing help inside the game, the hyperlinks will appear in plain text like: "See Connecting to the Game (/help/login/connect)".  You will have to type `help login connect` (without the slashes) to view that help file.  If you're reading help on the Web Portal, they will be actual hyperlinks.



