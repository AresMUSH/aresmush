$:.unshift File.dirname(__FILE__)
load "lib/helpers.rb"
load "lib/luck_award_cmd.rb"
load "lib/luck_model.rb"
load "lib/luck_spend_cmd.rb"
load "luck_interfaces.rb"

module AresMUSH
  module FS3Luck
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("fs3luck", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/admin_luck.md", "help/luck.md" ]
    end
 
    def self.config_files
      [ "config_luck.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.handle_command(client, cmd)
       Global.dispatcher.temp_dispatch(client, cmd)
    end

    def self.handle_event(event)
    end
  end
end