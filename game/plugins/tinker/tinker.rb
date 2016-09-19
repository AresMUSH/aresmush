$:.unshift File.dirname(__FILE__)
load "lib/tinker_cmd.rb"

module AresMUSH
  module Tinker
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
      [ "help/tinker.md" ]
    end
 
    def self.config_files
      [  ]
    end
 
    def self.locale_files
      [  ]
    end
 
    def self.handle_command(client, cmd)
       false
    end

    def self.handle_event(event)
    end
  end
end