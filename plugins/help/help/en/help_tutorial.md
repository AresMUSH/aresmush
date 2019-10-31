---
toc: 1 - Getting Started
tutorial: true
summary: Learn about the help system.
order: 3
---
# Help Tutorial

The MUSH help system is here to help you learn how to use the in-game commands.  

[[toc]]

## Viewing Help

The best way to read the help articles is on the web portal (usually under Help -> Game Help) because it's easy to browse around with hyperlinks.  You can also view help in-game using the `help` command.  

![Help Page Screenshot](https://aresmush.com/images/help-images/help.png)

> **Tip:** If you're viewing help inside the game, the hyperlinks will appear in plain text like: "See Connecting to the Game (/help/login/connect)".  You will have to type `help login connect` (without the slashes) to view that help file.  If you're reading help on the web portal, they will be actual hyperlinks.

## Tutorials

The first collection of help articles are the **Tutorials**.  Great for beginners, these give an overview of each main system in the game, highlighting key features available on both the web portal and through a MU Client.  

Tutorials are under `help <system> tutorial` -- e.g. `help chat tutorial`.

## Command Reference

Veteran players will be more interested in the command reference help files.  These are focused on just the MU client commands.  There is generally one article for the main commands and one for admin/restricted commands.  For example:

* `help channels` - Main commands.
* `help manage channels` - Admin/restricted commands.

If you already know a command name and just can't remember the syntax, the `quickref` command (aliased to qr) can look it up without spamming you with the full help file.  For example, `qr scene/start` will show you the syntax for the start scene command.

## Command Arguments

Command arguments appear in angle-brackets like `<command name>`.   So if a command tells you `page <recipient>=<message>` then the actual command you'd type would be something like `page Faraday=Hi there!`  

Sometimes arguments are optional.  Optional arguments are indicated with square brackets.  So if a command tells you `channel/join <channel>[=<alias>]` it means the alias is optional.

Many commands use the slash character for different sub-commands.  For example:  `channel/join`, `channel/leave`, `channel/who`, etc.

## Multi-Page Commands

Many commands, including help, show a "page x of y" message at the bottom of the command text.  You can use a number after the command name to see each page - e.g., help, help2, help3, etc.  This works with commands that have switches too, so you can do requests2/all.


