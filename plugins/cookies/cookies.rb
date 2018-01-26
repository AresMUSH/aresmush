$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Cookies
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("cookies", "shortcuts")
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      return nil if !cmd.root_is?("cookie")
      
      case cmd.switch
      when "here"
        return CookieHereCmd
      when "total"
        return CookiesTotalCmd
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
