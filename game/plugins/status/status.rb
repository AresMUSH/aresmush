$:.unshift File.dirname(__FILE__)
load "lib/afk_cron_handler.rb"
load "lib/duty_cmd.rb"
load "lib/go_afk_cmd.rb"
load "lib/go_offstage_cmd.rb"
load "lib/go_onstage_cmd.rb"
load "lib/helpers.rb"
load "lib/ooc_catcher_cmd.rb"
load "lib/playerbit_cmd.rb"
load "lib/status_model.rb"
load "status_interfaces.rb"

module AresMUSH
  module Status
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("status", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/admin_duty.md", "help/afk.md", "help/offstage.md", "help/onstage.md", "help/playerbit.md", "help/status.md" ]
    end
 
    def self.config_files
      [ "config_status.yml" ]
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