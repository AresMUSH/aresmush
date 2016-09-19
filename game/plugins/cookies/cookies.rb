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
 
    def self.help_files
      [ "help/cookies.md" ]
    end
 
    def self.config_files
      [ "config_cookies.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.handle_command(client, cmd)
       Global.dispatcher.temp_dispatch(client, cmd)
    end

    def self.handle_event(event)
    end
  end
end