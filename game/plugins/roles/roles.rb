$:.unshift File.dirname(__FILE__)
load "lib/admin_list_cmd.rb"
load "lib/admin_note_cmd.rb"
load "lib/helpers.rb"
load "lib/roles_add_cmd.rb"
load "lib/roles_cmd.rb"
load "lib/roles_model.rb"
load "lib/roles_remove_cmd.rb"
load "roles_events.rb"
load "roles_interfaces.rb"
load "templates/admin_template.rb"

module AresMUSH
  module Roles
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("roles", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/admin.md", "help/admin_admin.md", "help/roles.md" ]
    end
 
    def self.config_files
      [ "config_roles.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.handle_command(client, cmd)
       Global.dispatcher.temp_dispatch(client, cmd)
    end

    def self.handle_event(event)
    end
  end
end