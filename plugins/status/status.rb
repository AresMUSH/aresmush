$:.unshift File.dirname(__FILE__)
load "engine/afk_cron_handler.rb"
load "engine/duty_cmd.rb"
load "engine/go_afk_cmd.rb"
load "engine/go_offstage_cmd.rb"
load "engine/go_onstage_cmd.rb"
load "engine/npc_cmd.rb"
load "engine/playerbit_cmd.rb"
load "lib/helpers.rb"
load "lib/status_model.rb"
load "lib/status_api.rb"

module AresMUSH
  module Status
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("status", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.config_files
      [ "config_status.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "duty"
        return DutyCmd
      when "afk"
        return GoAfkCmd
      when "npc"
        return NpcCmd
      when "offstage"
        return GoOffstageCmd
      when "onstage"
        return GoOnstageCmd
      when "ooc"
        if (!cmd.args)
          return GoOffstageCmd
        end
      when "playerbit"
        return PlayerBitCmd
      end      
      nil
    end

    def self.get_event_handler(event_name) 
      nil
    end
  end
end