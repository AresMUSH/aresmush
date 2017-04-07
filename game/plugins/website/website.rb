$:.unshift File.dirname(__FILE__)

load 'web/web.rb'
load 'web/help.rb'
load 'web/chargen.rb'
load 'web/characters.rb'
load 'web/admin/config.rb'
load 'web/admin/fs3_skills.rb'
load 'web/admin/game_info.rb'
load 'web/admin/game_prefs.rb'
load 'web/admin/admin.rb'
load 'web/admin/logs.rb'
load 'web/login.rb'
load 'web/register.rb'
load 'web_cmd_handler.rb'
load 'recaptcha_helper.rb'

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