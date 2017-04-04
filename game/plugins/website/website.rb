$:.unshift File.dirname(__FILE__)

load 'web/web.rb'
load 'web/config.rb'
load 'web/help.rb'
load 'web/chargen.rb'
load 'web/characters.rb'
load 'web/admin.rb'
load 'web/login.rb'
load 'web/register.rb'
load 'web/logs.rb'
load 'web/setup.rb'
load 'web_cmd_handler.rb'


module AresMUSH
  module Website
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
      [  ]
    end
 
    def self.config_files
      [  ]
    end
 
    def self.locale_files
      [ ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)       
      nil
    end

    def self.get_event_handler(event_name) 
      if (event_name == "WebCmdEvent")
        return WebCmdEventHandler
      end
      
      nil
    end
  end
end