---
toc: ~admin~ Coding
summary: Loading code.
aliases:
- unload
- reload
---
# Loading Code

> **Permission Required:** These commands require the Admin role or the manage\_game permission.

Plugin code, help files, configuration files and translation (locale) files are all stored on disk on the server. When you make code changes, plugin code can be loaded dynamically without restarting the server.

> Note: Reloading code doesn't affect the game engine, which can only be updated by shutting down and restarting the game.

`plugins` - Lists plugins.
`load <plugin name>` - Loads/reloads a plugin from disk. Loading a plugin automatically also reloads config, locale and help

## Loading Config and Locale

Loading a plugin will reload its configuration and locale (translations). Config changes made through the web portal editor are also automatically loaded. It shouldn't be necessary to load the config or locale manually, but you can do so:

`load config` - Reloads configuration from disk.
`load locale` - Reloads translation files (locale) from disk.

## Loading Styles

Changes to the CSS styles made through the web portal will be loaded automatically. If you change them manually on disk, you can have the game reload the styles without re-deploying the entire website:

`load styles` - Reloads the CSS files.

## Loading Everything

When changing multiple things at once, you can reload all the plugins, the config and the translations at the same time.

`load all` - Reloads everything.

**Note:** Be careful with `load all`, because if it goes awry it can leave your system in an unpredictable state.

## Unloading Plugin Code

You can unload an entire plugin, but this must be done with caution. 

> Note: Unloading a plugin is not normally necessary, and if done inappropriately can cause errors in your game. 

Only unload a plugin if 
a) You added it yourself, like custom code or an ares extra you installed or 
b) You have done the necessary code surgery to ensure it can be excised safely. See the [coding tutorials](https://aresmush.com/tutorials/code/plugins.html) for more information.

`unload <plugin name>` - Unloads a plugin. See notes for important cautions.

