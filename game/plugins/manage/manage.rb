$:.unshift File.dirname(__FILE__)
load "lib/db/backup_cmd.rb"
load "lib/db/destroy_cmd.rb"
load "lib/db/destroy_confirm_cmd.rb"
load "lib/db/examine_cmd.rb"
load "lib/db/find_cmd.rb"
load "lib/db/rename_cmd.rb"
load "lib/game/findsite_all_cmd.rb"
load "lib/game/announce_cmd.rb"
load "lib/game/config_list_cmd.rb"
load "lib/game/config_view_cmd.rb"
load "lib/game/git_cmd.rb"
load "lib/game/load_config_cmd.rb"
load "lib/game/load_locale_cmd.rb"
load "lib/game/load_plugin_cmd.rb"
load "lib/game/plugin_list_cmd.rb"
load "lib/game/shutdown_cmd.rb"
load "lib/game/unload_plugin_cmd.rb"
load "lib/game/version_cmd.rb"
load "lib/aws_backup.rb"
load "lib/cron_event_handler.rb"
load "lib/helpers.rb"
load "lib/trouble/findsite_cmd.rb"
load "public/manage_api.rb"
load "public/manage_events.rb"
load "public/manage_model.rb"

module AresMUSH
  module Manage
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("manage", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.config_files
      [ "config_manage.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
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