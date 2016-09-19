$:.unshift File.dirname(__FILE__)
load "help_interfaces.rb"
load "lib/help_list_cmd.rb"
load "lib/help_view_cmd.rb"
load "lib/helpers.rb"

module AresMUSH
  module Help
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("help", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/help.md" ]
    end
 
    def self.config_files
      [ "config_help.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.handle_command(client, cmd)
       false
    end

    def self.handle_event(event)
    end
  end
end