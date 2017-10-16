$:.unshift File.dirname(__FILE__)

load "lib/ictime_cmd.rb"
load "public/ictime_api.rb"

module AresMUSH
  module ICTime
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("ictime", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.config_files
      [ "config_ictime.yml" ]
    end
 
    def self.locale_files
      [ ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "ictime"
        return IctimeCmd
      end
      
      nil
    end

    def self.get_event_handler(event_name) 
      nil
    end
  end
end