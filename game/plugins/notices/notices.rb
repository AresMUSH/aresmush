$:.unshift File.dirname(__FILE__)
load "lib/login_events.rb"
load "templates/notices_template.rb"

module AresMUSH
  module Notices
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
      [ "locales/locale_en.yml" ]
    end
 
    def self.handle_command(client, cmd)
       Global.dispatcher.temp_dispatch(client, cmd)
    end

    def self.handle_event(event)
    end
  end
end