$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Demographics
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      if Global.read_config("demographics", "disable_auto_shortcuts")
        return Global.read_config("demographics", "shortcuts")
      end
      
      sc = {}
      Global.read_config("demographics", "demographics").each do |d|
        if (d != 'birthdate')
          sc[d] = "demographic/set #{d}="
        end
      end
      Demographics.all_groups.keys.map { |g| g.downcase}.each do |g|
        sc[g] = "group/set #{g}="
        sc["#{g}s"] = "group #{g}"
      end
      Global.read_config("demographics", "shortcuts").each do |k, v|
        sc[k] = v
      end
      sc
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
        if (cmd.args)
          return BasicDemographicCmd
        else
          return DemographicsListCmd
        end
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
    
    def self.get_web_request_handler(request)
      case request.cmd
      when "actors"
        return ActorsRequestHandler
      when "censusFull"
        return FullCensusRequestHandler
      when "censusGroup"
        return GroupCensusRequestHandler
      when "censusTypes"
        return CensusTypesRequestHandler
      end
      nil
    end
    
  end
end
