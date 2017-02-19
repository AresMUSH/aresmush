$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Custom
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("custom", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ ]
    end
 
    def self.config_files
      [ "config_custom.yml" ]
    end
 
    def self.locale_files
      [ ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      nil     
    end

    def self.get_event_handler(event_name) 
      nil
    end
  end
end