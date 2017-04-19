$:.unshift File.dirname(__FILE__)

load 'web/controllers/web.rb'
load 'web/controllers/help.rb'
load 'web/controllers/chargen.rb'
load 'web/controllers/characters.rb'
load 'web/controllers/config.rb'
load 'web/controllers/fs3_combat.rb'
load 'web/controllers/fs3_skills.rb'
load 'web/controllers/game_info.rb'
load 'web/controllers/game_prefs.rb'
load 'web/controllers/admin.rb'
load 'web/controllers/logs.rb'
load 'web/controllers/login.rb'
load 'web/controllers/register.rb'
load 'web_cmd_handler.rb'
load 'recaptcha_helper.rb'
load 'website_cmd.rb'

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
 
    def self.config_files
      [  ]
    end
 
    def self.locale_files
      [ ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)       
      if (cmd.root == "website")
        return WebsiteCmd
      end
      
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