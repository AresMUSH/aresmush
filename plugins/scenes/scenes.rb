$:.unshift File.dirname(__FILE__)


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
        when "location", "privacy", "summary", "title", "type", "icdate", "plot"
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
