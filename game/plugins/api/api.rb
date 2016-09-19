$:.unshift File.dirname(__FILE__)
load "arescentral.rb"
load "lib/event_handlers.rb"
load "lib/game.rb"

module AresMUSH
  module Api
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("api", "shortcuts")
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
      [ "config_api.yml" ]
    end
 
    def self.locale_files
      [  ]
    end
 
    def self.handle_command(client, cmd)
       Global.dispatcher.temp_dispatch(client, cmd)
    end

    def self.handle_event(event)
    end
  end
end