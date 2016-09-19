$:.unshift File.dirname(__FILE__)
load "lib/helpers.rb"
load "lib/login_events.rb"
load "lib/time_cmd.rb"
load "lib/time_model.rb"
load "lib/timezone_cmd.rb"
load "time_interfaces.rb"

module AresMUSH
  module OOCTime
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      {}
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/time.md" ]
    end
 
    def self.config_files
      [ "config_time.yml" ]
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