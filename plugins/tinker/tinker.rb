$:.unshift File.dirname(__FILE__)
load "engine/tinker_cmd.rb"
load "web/tinker.rb"

module AresMUSH
  module Tinker
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
    
    def self.config_files
      [ ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      if (cmd.root_is?("tinker"))
        return TinkerCmd
      end
      
      nil
    end

    def self.get_event_handler(event_name) 
      nil
    end
  end
end