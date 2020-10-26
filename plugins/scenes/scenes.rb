$:.unshift File.dirname(__FILE__)


module AresMUSH
  module Scenes
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("scenes", "shortcuts")
    end
    
    def self.achievements
      list = Global.read_config("scenes", "achievements") || {}
      
      # Automatically add achievements for the various scene types.
      Scenes.scene_types.each do |type|
        list["scene_participant_#{type.downcase}"] = { 'type' => 'story', 'message' => "Participated in a #{type} scene." }
      end
      list
    end
    
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "autospace"
        return AutospaceCmd
      when "nospoof"
        return NospoofCmd
      when "ooc"
        # ooc by itself is an alias for offstage
        if (cmd.args)
          return PoseCmd
        end
      when "emit"
        case cmd.switch
        when "set", "gm"
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
        when "ordertype"
          return PoseOrderTypeCmd
        end
        
      when "quotecolor"
        return QuoteColorCmd
      
      when "scene"
        case cmd.switch
        when "all", "open"
          return ScenesCmd
        when nil
          if (cmd.args)
            return SceneLogCmd
          else
            return ScenesCmd
          end
        when "addchar", "removechar"
          return SceneCharCmd
        when "emit"
          return SceneEmitCmd
        when "home"
          return SceneHomeCmd
        when "join"
          return SceneJoinCmd
        when "location", "privacy", "summary", "title", "type", "icdate", "plot", "limit", "notes", "note", "pacing", "warning"
          return SceneInfoCmd
        when "delete"
          return SceneDeleteCmd
        when "invite", "uninvite"
          return SceneInviteCmd
        when "leave"
          return SceneLeaveCmd
        when "undo"
          return SceneUndoCmd
        when "replace", "typo"
          return SceneReplaceCmd
        when "restart"
          return SceneRestartCmd
        when "start"
          return SceneStartCmd
        when "stop"
          return SceneStopCmd
        when "types"
          return SceneTypesCmd
        when "log"
          return SceneLogCmd
        when "clearlog"
          return SceneLogClearCmd
        when "enablelog", "disablelog"
          return SceneLogEnableCmd
        when "repose"
          return SceneReposeCmd
        when "report"
          return SceneReportCmd
        when "share"
          return SceneShareCmd
        when "unshare"
          return SceneUnshareCmd
        when "unshared"
          return ScenesCmd
        when "webstart"
          return SceneWebStartCmd
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
    
    def self.get_web_request_handler(request)
      case request.cmd
      when "addScenePose"
        return AddScenePoseRequestHandler
      when "changeSceneLocation"
        return ChangeSceneLocationHandler
      when "changeSceneStatus"
        return ChangeSceneStatusRequestHandler
      when "collapseScenePoses"
        return CollapseScenePosesRequestHandler
      when "createPlot"
        return CreatePlotRequestHandler
      when "createScene"
        return CreateSceneRequestHandler
      when "editScenePose"
        return EditScenePoseRequestHandler
      when "deleteScenePose"
        return DeleteScenePoseRequestHandler
      when "deletePlot"
        return DeletePlotRequestHandler
      when "deleteScene"
        return DeleteSceneRequestHandler
      when "downloadScene"
        return DownloadSceneRequestHandler
      when "dropPoseOrder"
        return DropPoseOrderRequestHandler
      when "editPlot"
        return EditPlotRequestHandler
      when "editScene"
        return EditSceneRequestHandler
      when "joinScene"
        return JoinSceneRequestHandler
      when "likeScene"
        return LikeSceneRequestHandler
      when "liveScenes"
        return LiveScenesRequestHandler        
      when "liveScene"
        return LiveSceneRequestHandler  
      when "markSceneRead"
        return MarkSceneReadRequestHandler
      when "myScenes"
        return MyScenesRequestHandler     
      when "plots"
        return PlotsRequestHandler
      when "plot"
        return PlotRequestHandler
      when "recentScenes"
        return RecentScenesRequestHandler
      when "reportScene"
        return ReportSceneRequestHandler
      when "scene"
        return GetSceneRequestHandler
      when "scenes"
        return GetScenesRequestHandler
      when "sceneLocations"
        return GetSceneLocationsHandler
      when "sceneOptions"
        return GetSceneOptionsRequestHandler
      when "searchScenes"
        return SearchScenesRequestHandler
      when "switchPoseOrder"
        return SwitchPoseOrderRequestHandler
      when "unsharedScenes"
        return UnsharedScenesRequestHandler
      when "unwatchScene"
        return UnwatchSceneRequestHandler
      when "watchScene"
        return WatchSceneRequestHandler
      end
      nil
    end
    
    def self.check_config
      validator = ScenesConfigValidator.new
      validator.validate
    end
  end
end
