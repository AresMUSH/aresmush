$:.unshift File.dirname(__FILE__)
load "idle_interfaces.rb"
load "lib/helpers.rb"
load "lib/idle_action_cmd.rb"
load "lib/idle_execute_cmd.rb"
load "lib/idle_model.rb"
load "lib/idle_queue_cmd.rb"
load "lib/idle_remove_cmd.rb"
load "lib/idle_start_cmd.rb"
load "lib/lastwill_cmd.rb"

module AresMUSH
  module Idle
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("idle", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/admin_idle.md", "help/lastwill.md" ]
    end
 
    def self.config_files
      [ "config_idle.yml" ]
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