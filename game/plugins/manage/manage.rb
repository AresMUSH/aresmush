$:.unshift File.dirname(__FILE__)
load "lib/db/destroy_cmd.rb"
load "lib/db/destroy_confirm_cmd.rb"
load "lib/db/examine_cmd.rb"
load "lib/db/find_cmd.rb"
load "lib/db/rename_cmd.rb"
load "lib/game/announce_cmd.rb"
load "lib/game/config_list_cmd.rb"
load "lib/game/config_view_cmd.rb"
load "lib/game/git_cmd.rb"
load "lib/game/load_config_cmd.rb"
load "lib/game/load_locale_cmd.rb"
load "lib/game/load_plugin_cmd.rb"
load "lib/game/plugin_list_cmd.rb"
load "lib/game/reload_cmd.rb"
load "lib/game/shutdown_cmd.rb"
load "lib/game/unload_plugin_cmd.rb"
load "lib/game/version_cmd.rb"
load "lib/helpers.rb"
load "lib/manage_model.rb"
load "lib/trouble/boot_cmd.rb"
load "lib/trouble/findsite_cmd.rb"
load "manage_api.rb"
load "manage_events.rb"

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
 
    def self.help_files
      [ "help/builder_db.md", "help/database.md", "help/git.md", "help/manage.md", "help/trouble.md" ]
    end
 
    def self.config_files
      [ "config_manage.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd)
      case cmd.root
      when "announce"
        return AnnounceCmd
      when "boot"
        return BootCmd
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
        return FindsiteCmd
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
      when "reload"
        return ReloadCmd
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
      nil
    end
  end
end