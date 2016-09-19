$:.unshift File.dirname(__FILE__)
load "handle_interface.rb"
load "lib/event_handlers.rb"
load "lib/handle_link_cmd.rb"
load "lib/handles_model.rb"

module AresMUSH
  module Handles
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
      [ "help/handles.md" ]
    end
 
    def self.config_files
      [  ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.handle_command(client, cmd)
       false
    end

    def self.handle_event(event)
    end
  end
end