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
      when "autospace"
        return AutospaceCmd
      when "nospoof"
        return NospoofCmd
      when "pemit"
        return Pemit
      when "ooc"
        # ooc by itself is an alias for offstage
        if (cmd.args)
          return PoseCmd
        end
      when "emit"
        case cmd.switch
        when "set"
          return SetPoseCmd
        else
          return PoseCmd
        end
      when "say"
        return PoseCmd
      when "pose"
        case cmd.switch
        when nil
          if (cmd.args)
            return PoseCmd
          else
            return PoseOrderCmd
          end
        when "drop"
          return PoseDropCmd
        when "nudge"
          return PoseNudgeCmd
        when "order"
          return PoseOrderCmd
        end
        
      when "quotecolor"
        return QuoteColorCmd
      
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
      
      if (cmd.raw.start_with?("\"") ||
          cmd.raw.start_with?("\\") ||
          cmd.raw.start_with?(":") ||
          cmd.raw.start_with?("'") ||
          cmd.raw.start_with?(">") ||
          cmd.raw.start_with?(";"))
        return PoseCatcherCmd
      end
      
      nil
    end

    def self.get_event_handler(event_name) 
      case event_name
      when "CronEvent"
        return CronEventHandler
      when "PoseEvent"
        return PoseEventHandler
      when "CharConnectedEvent"
        return CharConnectedEventHandler
      end
      nil
    end
  end
end
