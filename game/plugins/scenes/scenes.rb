$:.unshift File.dirname(__FILE__)

load "lib/event_handlers.rb"
load "lib/helpers.rb"
load "lib/scene_model.rb"
load "lib/scene_join_cmd.rb"
load "lib/scene_location_cmd.rb"
load "lib/scene_privacy_cmd.rb"
load "lib/scene_title_cmd.rb"
load "lib/scene_set_cmd.rb"
load "lib/scene_start_cmd.rb"
load "lib/scene_summary_cmd.rb"
load "lib/scene_stop_cmd.rb"
load "lib/scenes_cmd.rb"
load "lib/repose_cmd.rb"
load "lib/repose_clear_cmd.rb"
load "lib/repose_drop_cmd.rb"
load "lib/repose_nudge_cmd.rb"
load "lib/repose_order_cmd.rb"
load "lib/repose_set_cmd.rb"
load "templates/scenes_list_template.rb"
load "scenes_api.rb"

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
      when "repose"
        case cmd.switch
        when nil, "all"
          return ReposeCmd
        when "clear"
          return ReposeClearCmd
        when "drop"
          return ReposeDropCmd
        when "nudge"
          return ReposeNudgeCmd
        when "on", "off"
          return ReposeSetCmd
        when "order"
          return ReposeOrderCmd
        end
        
      when "scene"
        case cmd.switch
        when "join"
          return SceneJoinCmd
        when "location"
          return SceneLocationCmd
        when "set"
          return SceneSetCmd
        when "start"
          return SceneStartCmd
        when "stop"
          return SceneStopCmd
        when "summary"
          return SceneSummaryCmd
        when "title"
          return SceneTitleCmd
        when "privacy"
          return ScenePrivacyCmd
        end
      when "scenes"
        return ScenesCmd
      end
      nil
    end

    def self.get_event_handler(event_name) 
      case event_name
      when "CronEvent"
        return CronEventHandler
      when "GameStartedEvent"
        return GameStartedEventHandler
      when "CharConnectedEvent"
        return CharConnectedEventHandler
      end
      nil
    end
  end
end