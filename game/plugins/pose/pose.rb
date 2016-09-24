$:.unshift File.dirname(__FILE__)
load "pose_api.rb"
load "lib/helpers.rb"
load "lib/nospoof_cmd.rb"
load "lib/pemit_cmd.rb"
load "lib/pose_catcher_cmd.rb"
load "lib/pose_cmd.rb"
load "lib/pose_model.rb"

module AresMUSH
  module Pose
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("pose", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/autospace.md", "help/ooc.md", "help/posing.md" ]
    end
 
    def self.config_files
      [ "config_pose.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd)
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
      when "emit", "pose", "say"        
        return PoseCmd
      end
      
      if (cmd.raw.start_with?("\"") ||
          cmd.raw.start_with?("\\") ||
          cmd.raw.start_with?(":") ||
          cmd.raw.start_with?(";"))
        return PoseCatcherCmd
      end
      
      nil
    end

    def self.get_event_handler(event_name) 
      nil
    end
  end
end