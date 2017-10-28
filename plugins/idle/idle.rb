$:.unshift File.dirname(__FILE__)
load "engine/idle_action_cmd.rb"
load "engine/idle_execute_cmd.rb"
load 'engine/char_connected_event_handler.rb'
load 'engine/cron_event_handler.rb'
load "engine/idle_queue_cmd.rb"
load "engine/idle_remove_cmd.rb"
load "engine/idle_set_cmd.rb"
load "engine/idle_start_cmd.rb"
load "engine/lastwill_cmd.rb"
load "engine/roster_add_cmd.rb"
load "engine/roster_claim_cmd.rb"
load "engine/roster_list_cmd.rb"
load "engine/roster_data_cmd.rb"
load "engine/roster_restrict_cmd.rb"
load "engine/roster_remove_cmd.rb"
load "engine/roster_view_cmd.rb"
load "engine/templates/idle_queue_template.rb"
load "engine/templates/roster_list_template.rb"
load "engine/templates/roster_detail_template.rb"
load "lib/helpers.rb"
load "lib/idle_api.rb"
load "lib/idle_model.rb"
load "web/idle.rb"

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
 
    def self.config_files
      [ "config_idle.yml"]
    end
    
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "idle"
        case cmd.switch
        when "action", "gone", "npc", "dead", "warn", "roster"
          return IdleActionCmd
        when "execute"
          return IdleExecuteCmd
        when "queue", nil
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
        when "add"
          return RosterAddCmd
        when "claim"
          return RosterClaimCmd
        when "note", "contact", "played"
          return RosterDataCmd
        when "remove"
          return RosterRemoveCmd
        when "restrict"
          return RosterRestrictCmd
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
      when "CronEvent"
        return CronEventHandler
      end
      nil
    end
  end
end