$:.unshift File.dirname(__FILE__)
load "lib/cookie_cmd.rb"
load "lib/cookie_cron_handler.rb"
load "lib/cookie_here_cmd.rb"
load "lib/cookie_model.rb"
load "lib/cookies_cmd.rb"
load "lib/helpers.rb"

module AresMUSH
  module Cookies
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("cookies", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.config_files
      [ "config_cookies.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      return nil if !cmd.root_is?("cookie")
      
      case cmd.switch
      when "here"
        return CookieHereCmd
      when nil
        if (cmd.args)
          return CookieCmd
        else
          return CookiesCmd
        end
      end
      
      return nil
    end

    def self.get_event_handler(event_name) 
      case event_name
      when "CronEvent"
        return CronEventHandler
      end
      nil
    end
  end
end