$:.unshift File.dirname(__FILE__)
load "ictime_api.rb"
load "lib/helpers.rb"
load "lib/ictime_cmd.rb"

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
 
    def self.help_files
      [ "help/ictime.md" ]
    end
 
    def self.config_files
      [ "config_ictime.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
       if (cmd.root_is?("ictime"))
         return ICTimeCmd
       end
       
       nil
    end

    def self.get_event_handler(event_name) 
      nil
    end
  end
end