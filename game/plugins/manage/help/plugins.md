---
toc: ~admin~ Coding
summary: Managing plugins and config.
aliases:
- load
- unload
- plugin
- config
- announce
- wall
- reload
---
# Managing Plugins

> **Permission Required:** These commands require the Admin role or the manage\_game permission.

Plugin code, help files, configuration files and translation (locale) files are all stored on disk on the server.  To make changes to these things, you need to edit them on disk and then tell the game to reload them using one of these management commands.

## Loading Plugin Code

Plugin code can be loaded and unloaded dynamically without restarting the server.

`plugins` - Lists plugins.
`load <plugin name>` - Loads/reloads a plugin from disk.
       Loading a plugin automatically also reloads config, locale and help
`unload <plugin name>` - Unloads a plugin.
       Unloading is normally not necessary unless you have trouble loading a plugin 
       or wish to remove it completely.

## Loading Plugin Config

You can also view and load the plugin configuration files.

`config` - Lists config sections
`config <section>` - Views config variables for a section.
`load config` - Reloads configuration from disk.
   
## Loading Locale Translations

The plugin translation files must be loaded separately.

`load locale` - Reloads translation files (locale) from disk.
