---
toc: 1 - Getting Started
summary: Learn about the help system.
order: 1
---
# Help System

If you are looking for basic help about how the game is played, check out the [MUSH 101 Tutorial](http://www.aresmush.com/mush-101)

The MUSH help system is here to help you learn how to use the in-game commands.  On the game's [Web Portal](/help/website) you will find detailed tutorials about all the major systems.  

## Help Syntax

Help files will tell you what commands to type in the game.  Most commands take arguments, or options.

Command arguments appear in angle-brackets like `<command name>`.   So if a command tells you `page <recipient>=<message>` then the actual command you'd type would be something like `page Faraday=This is what I want to send to Faraday.`  

Sometimes arguments are optional.  Optional arguments are indicated with square brackets.  So if a command tells you `channel/join <channel>[=<alias>]` then the alias is optional.  You could do `channel/join Chat` or `channel/join Chat=c`.

## Help Index

The help command by itself will show you a list of all help topics.

`help, help2, help3, etc.` - Shows each page of help topics.

> **Tip:**  Many commands show a "page x of y" message at the bottom of the command text.  You can use a number after the command name to see each page - e.g., help, help2, help3, etc.  This works with commands that have switches too, so you can do requests2/all.

## Detailed Help Files

You can specify the help topic name to see detailed help for a topic or command.  If you're not sure of the name, partial matches and keywords will often work too.

`help <topic name>` - Searches the help and shows the full help text.

> Note: If you're viewing help inside the game, the hyperlinks will appear in plain text like: "See \[Connecting to the Game\](/help/login/connect)".  You will have to type `help login connect` (without the slashes) to view that help file.

## Help Quick Reference

If you already know the command name and just can't remember the syntax, the `quickref` command (aliased to qr) can look it up without spamming you with the full help file.

`quickref <command name>` - Views quick command syntax.



