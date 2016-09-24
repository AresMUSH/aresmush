$:.unshift File.dirname(__FILE__)
load "groups_api.rb"
load "lib/census_cmd.rb"
load "lib/group_set_cmd.rb"
load "lib/groups_cmd.rb"
load "lib/groups_detail_cmd.rb"
load "lib/groups_model.rb"
load "lib/helpers.rb"
load "templates/complete_census_template.rb"
load "templates/gender_census_template.rb"
load "templates/group_census_template.rb"
load "templates/group_detail_template.rb"
load "templates/group_list_template.rb"

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
 
    def self.get_cmd_handler(client, cmd)
      case cmd.root
      when "census"
        return CensusCmd
      when "group"
        case cmd.switch
        when "set"
          return GroupSetCmd
        when nil
          if (cmd.args)
            return GroupDetailCmd
          else
            return GroupsCmd
          end
        end
      end
      nil
    end

    def self.get_event_handler(event_name) 
      nil
    end
  end
end