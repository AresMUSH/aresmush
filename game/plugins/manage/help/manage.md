Plugin code, help files, configuration files and translation (locale) files are all stored on disk on the server.  To make changes to these things, you need to edit them on disk and then tell the game to reload them using one of these management commands.

%xhPlugin Management%xn
   %xcplugins%xn - Lists plugins.
   %xcload <plugin directory name>%xn - Loads/reloads a plugin from disk.
       Loading a plugin automatically also reloads config, locale and help
   %xcunload <plugin module name>%xn - Unloads a plugin.
       Unloading is normally not necessary unless you have trouble loading a plugin 
       or wish to remove it completely.  Unloading does not affect configuration or
       help, so you may want to reload them when you're done.
       
%xhConfig Management%xn
   %xcconfig%xn - Lists config sections
   %xcconfig <section>%xn - Views config variables for a section.
   %xcload config%xn - Reloads configuration from disk.
   
%xhOther Commands%xn
   %xcload help%xn - Reloads help files from disk.
   %xcload locale%xn - Reloads translation files (locale) from disk.
   %xcannounce <message>%xn - Announces something to all logged-in characters.