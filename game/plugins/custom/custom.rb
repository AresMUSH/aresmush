$:.unshift File.dirname(__FILE__)

load "qual_cmd.rb"
load "condition_cmd.rb"
load "kill_cmd.rb"

module AresMUSH
  module Custom
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("custom", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
     
    def self.config_files
      [ "config_custom.yml" ]
    end
 
    def self.locale_files
      [ ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "condition"
        return ConditionCmd
      when "qual"
        return QualCmd
      when "kill"
        return KillCmd
      end
      nil     
    end

    def self.get_event_handler(event_name) 
      nil
    end
  end
end