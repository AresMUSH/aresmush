$:.unshift File.dirname(__FILE__)
load "lib/helpers.rb"
load "lib/roster_add_cmd.rb"
load "lib/roster_claim_cmd.rb"
load "lib/roster_list_cmd.rb"
load "lib/roster_model.rb"
load "lib/roster_remove_cmd.rb"
load "lib/roster_view_cmd.rb"
load "roster_api.rb"
load "templates/roster_list_template.rb"
load "templates/roster_detail_template.rb"

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
 
    def self.get_cmd_handler(client, cmd)
       return if !cmd.root_is?("roster")
       
       case cmd.switch
       when "add", "update"
         return RosterAddCmd
       when "claim"
         return RosterClaimCmd
       when "remove"
         return RosterRemoveCmd
       when nil
         if (cmd.args)
           return RosterViewCmd
         else
           return RosterListCmd
         end
       end
       
       nil
    end

    def self.get_event_handler(event_name) 
      nil
    end
  end
end