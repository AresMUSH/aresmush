$:.unshift File.dirname(__FILE__)
load "lib/helpers.rb"
load "lib/roster_add_cmd.rb"
load "lib/roster_claim_cmd.rb"
load "lib/roster_list_cmd.rb"
load "lib/roster_model.rb"
load "lib/roster_remove_cmd.rb"
load "lib/roster_view_cmd.rb"
load "roster_interfaces.rb"
load "templates/roster_template.rb"

module AresMUSH
  module Roster
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("roster", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/admin_roster.md", "help/roster.md" ]
    end
 
    def self.config_files
      [ "config_roster.yml" ]
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