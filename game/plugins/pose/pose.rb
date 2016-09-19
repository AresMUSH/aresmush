$:.unshift File.dirname(__FILE__)
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
      [ "help/ooc.md", "help/posing.md" ]
    end
 
    def self.config_files
      [ "config_pose.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.handle_command(client, cmd)
       false
    end

    def self.handle_event(event)
    end
  end
end