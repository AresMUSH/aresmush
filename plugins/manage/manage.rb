$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Manage
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("manage", "shortcuts")
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "announce"
        return AnnounceCmd
      when "dbbackup"
        return BackupCmd
      when "config"
        case cmd.switch
        when nil
          if (cmd.args)
            return ConfigViewCmd
          else
            return ConfigListCmd
          end
        end
      when "destroy"
        case cmd.switch
        when "confirm"
          return DestroyConfirmCmd
        when nil
          return DestroyCmd
        end
      when "examine"
        return ExamineCmd
      when "find"
        return FindCmd
      when "findsite"
        if (cmd.args)
          return FindsiteCmd
        else
          return FindsiteAllCmd
        end
      when "git"
        return GitCmd
      when "load"
        case cmd.args
        when "config"
          return LoadConfigCmd
        when "locale"
          return LoadLocaleCmd
        else
          return LoadPluginCmd
        end
      when "plugins"
        return PluginListCmd
      when "rename"
        return RenameCmd
      when "shutdown"
        return ShutdownCmd
      when "statue", "unstatue"
        return StatueCmd
      when "unload"
        return UnloadPluginCmd
      when "version"
        return VersionCmd
      end
      
      nil
    end

    def self.get_event_handler(event_name) 
      case event_name
      when "CronEvent"
        return CronEventHandler
      end
      nil
    end
  end
end
