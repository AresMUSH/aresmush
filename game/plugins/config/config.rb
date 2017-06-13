$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Config
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
      []
    end
 
    def self.locale_files
      []
    end
 
    def self.get_cmd_handler(client, cmd, enactor)      
      return nil
    end

    def self.get_event_handler(event_name) 
      nil
    end
  end
end