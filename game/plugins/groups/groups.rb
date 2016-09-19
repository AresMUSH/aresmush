$:.unshift File.dirname(__FILE__)
load "groups_interfaces.rb"
load "lib/census_cmd.rb"
load "lib/group_set_cmd.rb"
load "lib/groups_cmd.rb"
load "lib/groups_detail_cmd.rb"
load "lib/groups_model.rb"
load "lib/helpers.rb"
load "templates/complete_template.rb"
load "templates/gender_template.rb"
load "templates/group_template.rb"

module AresMUSH
  module Groups
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("groups", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/admin_groups.md", "help/census.md", "help/groups.md" ]
    end
 
    def self.config_files
      [ "config_groups.yml" ]
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