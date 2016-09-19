$:.unshift File.dirname(__FILE__)
load "demo_interfaces.rb"
load "lib/age_cmd.rb"
load "lib/basic_demographic_cmd.rb"
load "lib/birthday_cmd.rb"
load "lib/demo_model.rb"
load "lib/helpers.rb"

module AresMUSH
  module Demographics
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("demographics", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/demographics.md" ]
    end
 
    def self.config_files
      [ "config_demographics.yml" ]
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