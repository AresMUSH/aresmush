---
toc: Managing Code
summary: Managing plugins and config.
aliases:
- load
- unload
- plugin
- config
- announce
- wall
---
Plugin code, help files, configuration files and translation (locale) files are all stored on disk on the server.  To make changes to these things, you need to edit them on disk and then tell the game to reload them using one of these management commands.

**Plugin Management**
`plugins` - Lists plugins.
`load <plugin directory name>` - Loads/reloads a plugin from disk.
       Loading a plugin automatically also reloads config, locale and help
`unload <plugin module name>` - Unloads a plugin.
       Unloading is normally not necessary unless you have trouble loading a plugin 
       or wish to remove it completely.  Unloading does not affect configuration or
       help, so you may want to reload them when you're done.
 **Config Management**
`config` - Lists config sections
`config <section>` - Views config variables for a section.
`load config` - Reloads configuration from disk.
   
**Other Commands**
`load locale` - Reloads translation files (locale) from disk.
`announce <message>` - Announces something to all logged-in characters.
