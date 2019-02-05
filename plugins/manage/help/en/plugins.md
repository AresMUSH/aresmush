---
toc: ~admin~ Coding
summary: Managing plugins.
aliases:
- load
- unload
- plugin
- reload
---
# Managing Plugins

> **Permission Required:** These commands require the Admin role or the manage\_game permission.

Plugin code, help files, configuration files and translation (locale) files are all stored on disk on the server. 

> Note: Reloading doesn't affect the game engine, which can only be updated by shutting down and restarting the game.

## Loading Plugin Code

Plugin code can be loaded and unloaded dynamically without restarting the server.

`plugins` - Lists plugins.
`load <plugin name>` - Loads/reloads a plugin from disk.
       Loading a plugin automatically also reloads config, locale and help
`unload <plugin name>` - Unloads a plugin.
       Unloading is normally not necessary unless you have trouble loading a plugin 
       or wish to remove it completely.

## Loading Plugin Config

You can also reload the game configuration.  See [Config](/help/config).
   
## Loading Locale Translations

The plugin translation files must be loaded separately.

`load locale` - Reloads translation files (locale) from disk.

## Loading Styles

When you've made changes to the web portal CSS files, you can update just the styles without re-deploying the entire website.

`load styles` - Reloads the CSS files.

## Loading Everything

If you aren't sure what all you need to load, you can reload all the plugins, the config and the translations all at once.

`load all` - Reloads everything.
