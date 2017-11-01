$:.unshift File.dirname(__FILE__)

load "engine/pose_event_handler.rb"
load "engine/cron_event_handler.rb"
load "engine/helpers.rb"
load "engine/scene_addpose_cmd.rb"
load "engine/scene_char_cmd.rb"
load "engine/scene_clearlog_cmd.rb"
load "engine/scene_delete_cmd.rb"
load "engine/scene_enablelog_cmd.rb"
load "engine/scene_info_cmd.rb"
load "engine/scene_join_cmd.rb"
load "engine/scene_log_cmd.rb"
load "engine/scene_replace_cmd.rb"
load "engine/scene_restart_cmd.rb"
load "engine/scene_undo_cmd.rb"
load "engine/scene_set_cmd.rb"
load "engine/scene_share_cmd.rb"
load "engine/scene_unshare_cmd.rb"
load "engine/scene_start_cmd.rb"
load "engine/scene_stop_cmd.rb"
load "engine/scene_types_cmd.rb"
load "engine/scenes_cmd.rb"
load "engine/templates/scenes_list_template.rb"
load "engine/templates/scenes_summary_template.rb"
load "engine/templates/scene_log_template.rb"
load "lib/scenes_api.rb"
load "lib/scene_model.rb"
load "web/scene_create.rb"
load "web/scene_edit_participants.rb"
load "web/scene_edit_related.rb"
load "web/scene_edit.rb"
load "web/scenes.rb"

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
        when "all"
          return ScenesCmd
        when nil
          if (cmd.args)
            return SceneLogCmd
          else
            return ScenesCmd
          end
        when "addchar", "removechar"
          return SceneCharCmd
        when "addpose"
          return SceneAddPoseCmd
        when "join"
          return SceneJoinCmd
        when "location", "privacy", "summary", "title", "type", "icdate"
          return SceneInfoCmd
        when "delete"
          return SceneDeleteCmd
        when "undo"
          return SceneUndoCmd
        when "replace", "typo"
          return SceneReplaceCmd
        when "restart"
          return SceneRestartCmd
        when "set"
          return SceneSetCmd
        when "start"
          return SceneStartCmd
        when "stop"
          return SceneStopCmd
        when "types"
          return SceneTypesCmd
        when "log", "repose"
          return SceneLogCmd
        when "clearlog"
          return SceneLogClearCmd
        when "startlog", "stoplog"
          return SceneLogEnableCmd
        when "share"
          return SceneShareCmd
        when "unshare"
          return SceneUnshareCmd
        when "unshared"
          return ScenesCmd
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