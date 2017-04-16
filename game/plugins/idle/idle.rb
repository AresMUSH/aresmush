$:.unshift File.dirname(__FILE__)
load "idle_api.rb"
load "lib/helpers.rb"
load "lib/idle_action_cmd.rb"
load "lib/idle_execute_cmd.rb"
load 'lib/event_handling.rb'
load "lib/idle_model.rb"
load "lib/idle_queue_cmd.rb"
load "lib/idle_remove_cmd.rb"
load "lib/idle_set_cmd.rb"
load "lib/idle_start_cmd.rb"
load "lib/lastwill_cmd.rb"
load "lib/roster_add_cmd.rb"
load "lib/roster_claim_cmd.rb"
load "lib/roster_list_cmd.rb"
load "lib/roster_remove_cmd.rb"
load "lib/roster_view_cmd.rb"
load "templates/idle_queue_template.rb"
load "templates/roster_list_template.rb"
load "templates/roster_detail_template.rb"

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
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "idle"
        case cmd.switch
        when "action"
          return IdleActionCmd
        when "execute"
          return IdleExecuteCmd
        when "queue"
          return IdleQueueCmd
        when "remove"
          return IdleRemoveCmd
        when "set"
          return IdleSetCmd
        when "start"
          return IdleStartCmd
        end
      when "lastwill"
        return LastWillCmd
      when "roster"
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
      end
       
      nil
    end

    def self.get_event_handler(event_name) 
      case event_name
      when "CharConnectedEvent"
        return CharConnectedEventHandler
      end
      nil
    end
  end
end