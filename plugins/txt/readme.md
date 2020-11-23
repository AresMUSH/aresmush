# Text System

## Credit
This plugin has been updated and is now maintained by Tat @ Ares Central. Original credit for the code goes to skew @ Ares Central.

## Overview

A command designed to mimic real world texting. It sends texts or other private messages from one person to multiple people.

It can send as a simple person-to-person emit (like pages), as a scene emit, or as a person-to-person emit that also logs to a scene.

Allows users to choose their text color, reply to their previous text, and start new scenes with a text.

## Installation
In the game, run `plugin/install <github url>`.

### Page Command

This plugin references the default AresMUSH page command. If that is not installed, this won't work. Specifically, it uses the DND and page lock features. If a person is set DND or page locked, you cannot txt them!

See additional setup instructions below.

## Configuring

### Message format

The text preface, start, and end markers are configurable in txt.yml. By default, texts display as: 

`(TXT to Tat) Skew : Hello there!`

You can further adjust the text format if you like. The message format is contained in `/aresmush/plugins/txt/locales/local_en.yml`.

###Nicknames

If you'd like nicknames to appear in the sender and recipient fields, you can toggle `use_nick` or `use_only_nick` true. Only mark ONE of these options as true.

Note that texts must still be SENT using the character's name and not their nickname.

`use_nick` - Changes the sender and recipient display to your nickname display as set up in `nickname_format` in demographics.yml.
`use_only_nick` - Changes the sender and recipient display to your nickname. Displays the sender's character name after the text, with the scene number.

###Location and Scene Type
Sets the defaults for `txt/newscene` to autofill the location and scene type of text scenes. Be sure that scene type matches one of your scene_types as set in scenes.yml.

## Uninstalling

Removing the plugin requires some code fiddling.  See [Uninstalling Plugins](https://www.aresmush.com/tutorials/code/extras.html#uninstalling-plugins).


## License

Same as [AresMUSH](https://aresmush.com/license).
