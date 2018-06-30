---
toc: ~admin~ Coding
summary: Managing plugins and config.
aliases:
- load
- unload
- plugin
- config
- reload
---
# Managing Plugins

> **Permission Required:** These commands require the Admin role or the manage\_game permission.

Plugin code, help files, configuration files and translation (locale) files are all stored on disk on the server.  To make changes to these things, you need to edit them on disk and then tell the game to reload them using one of these management commands.

Reloading doesn't affect the game engine, which can only be updated by shutting down and restarting the game.  However, game engine updates are very rare.

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

## Loading Styles

When you've made changes to the web portal CSS files, you can update just the styles without re-deploying the entire website.

`load styles` - Reloads the CSS files.

## Loading Everything

If you aren't sure what all you need to load, you can reload all the plugins, the config and the translations all at once.

`load all` - Reloads everything.