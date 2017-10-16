$:.unshift File.dirname(__FILE__)
load "lib/age_cmd.rb"
load "lib/actors_cmd.rb"
load "lib/actor_catcher_cmd.rb"
load "lib/actor_search_cmd.rb"
load "lib/actor_set_cmd.rb"
load "lib/basic_demographic_cmd.rb"
load "lib/birthday_cmd.rb"
load "lib/helpers.rb"
load "lib/census_cmd.rb"
load "lib/group_set_cmd.rb"
load "lib/groups_cmd.rb"
load "lib/groups_detail_cmd.rb"
load "public/demographics_api.rb"
load "public/demo_char.rb"
load "templates/actors_list.rb"
load "templates/complete_census_template.rb"
load "templates/gender_census_template.rb"
load "templates/group_census_template.rb"
load "templates/group_detail_template.rb"
load "templates/group_list_template.rb"
load "templates/skills_census_template.rb"
load "templates/rank_census_template.rb"

module AresMUSH
  module Demographics
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("demographics", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.config_files
      [ "config_demographics.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      
      case cmd.root
      when "actor"
        case cmd.switch
        when "set"
          return ActorSetCmd
        when "search"
          return ActorSearchCmd
        else
          return ActorCatcherCmd
        end
      when "actors"
        case cmd.switch
        when "set"
          return ActorSetCmd
        when "search"
          return ActorSearchCmd
        else
          return ActorsListCmd
        end
      when "age"
        return AgeCmd 
      when "birthdate"
        return BirthdateCmd       
      when "demographic"
        return BasicDemographicCmd
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