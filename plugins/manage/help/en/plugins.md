---
toc: ~admin~ Coding
summary: Managing plugins.
aliases:
- load
- unload
- plugin
- reload
- install
---
# Managing Plugins

> **Permission Required:** These commands require the Admin role or the manage\_game permission.

Plugin code, help files, configuration files and translation (locale) files are all stored on disk on the server. 

## Enabling and Disabling Plugins

Certain plugins are designated optional. These can be easily turned on and off without affecting the rest of the game. See [Plugin Config](https://aresmush.com/tutorials/config/plugins.html) for details.

To enable or disable optional plugins, go to the web portal under Admin->Setup->Enable or Disable Plugins.

## Installing Plugins and Themes

[Community Contributions](/help/community_contribs) offer additional plugins and themes for you to install.

## Loading Plugin Code

When you make code changes, plugin code can be loaded dynamically without restarting the server.

> Note: Reloading code doesn't affect the game engine, which can only be updated by shutting down and restarting the game.

`plugins` - Lists plugins.
`load <plugin name>` - Loads/reloads a plugin from disk. Loading a plugin automatically also reloads config, locale and help

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

## Unloading Plugin Code

You can unload an entire plugin, but this must be done with caution. 

> Note: Unloading a plugin is not normally necessary, and if done inappropriately can cause errors in your game. 

Only unload a plugin if 
a) You added it yourself, like custom code or an ares extra you installed or 
b) You have done the necessary code surgery to ensure it can be excised safely. See the [coding tutorials](https://aresmush.com/tutorials/code/plugins.html) for more information.

`unload <plugin name>` - Unloads a plugin. See notes for important cautions.

