$:.unshift File.dirname(__FILE__)

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
