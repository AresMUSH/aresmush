$:.unshift File.dirname(__FILE__)
load "lib/alias_cmd.rb"
load "lib/connect_cmd.rb"
load "lib/create_cmd.rb"
load "lib/email_set_cmd.rb"
load "lib/email_view_cmd.rb"
load "lib/helpers.rb"
load "lib/login_events.rb"
load "lib/login_model.rb"
load "lib/password_reset_cmd.rb"
load "lib/password_set_cmd.rb"
load "lib/quit_cmd.rb"
load "lib/tos_cmd.rb"
load "lib/tour_cmd.rb"
load "lib/watch_cmd.rb"
load "login_events.rb"
load "login_interfaces.rb"

module AresMUSH
  module Login
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("login", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/admin_login.md", "help/email.md", "help/login.md", "help/names.md", "help/watch.md" ]
    end
 
    def self.config_files
      [ "config_login.yml" ]
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