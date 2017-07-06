$:.unshift File.dirname(__FILE__)

load "lib/pose_event_handler.rb"
load "lib/cron_event_handler.rb"
load "lib/helpers.rb"
load "lib/log_cmd.rb"
load "lib/log_clear_cmd.rb"
load "lib/log_enable_cmd.rb"
load "lib/log_share_cmd.rb"
load "lib/scene_types_cmd.rb"
load "lib/scene_info_cmd.rb"
load "lib/scene_join_cmd.rb"
load "lib/scene_set_cmd.rb"
load "lib/scene_spoof_cmd.rb"
load "lib/scene_start_cmd.rb"
load "lib/scene_stop_cmd.rb"
load "lib/scenes_cmd.rb"
load "templates/scenes_list_template.rb"
load "templates/scenes_summary_template.rb"
load "public/scenes_api.rb"
load "public/scene_model.rb"

module AresMUSH
  module Scenes
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("scenes", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.config_files
      [ "config_scenes.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root

      when "scene"
        case cmd.switch
        when nil, "all"
          return ScenesCmd
        when "join"
          return SceneJoinCmd
        when "location", "privacy", "summary", "title", "type", "icdate"
          return SceneInfoCmd
        when "set"
          return SceneSetCmd
        when "start"
          return SceneStartCmd
        when "spoof"
          return SceneSpoofCmd
        when "stop"
          return SceneStopCmd
        when "types"
          return SceneTypesCmd
        when "log", "repose"
          return LogCmd
        when "clearlog"
          return LogClearCmd
        when "startlog", "stoplog"
          return LogEnableCmd
        when "share", "unshare"
          return LogShareCmd
        end
      end
      nil
    end

    def self.get_event_handler(event_name) 
      case event_name
      when "CronEvent"
        return CronEventHandler
      when "PoseEvent"
        return PoseEventHandler
      end
      nil
    end
  end
end