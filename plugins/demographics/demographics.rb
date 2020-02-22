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
      Demographics.all_demographics.each do |d|
        shortname = d.gsub(/\s+/, '')
        if (shortname != 'birthdate')
          sc[shortname] = "demographic/set #{d}="
        end
      end
      Demographics.all_groups.keys.map { |g| g.downcase}.each do |g|
        sc[g] = "group/set #{g}="
        sc["#{g}s"] = "group #{g}"
      end
      shortcuts = Global.read_config("demographics", "shortcuts") || []
      shortcuts.each do |k, v|
        sc[k] = v
      end
      sc
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      
      case cmd.root
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
        if (cmd.switch_is?("types"))
          return CensusTypesCmd
        else
          return CensusCmd
        end
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
      when "groupInfo"
        return GroupInfoRequestHandler
      end
      nil
    end
    
    def self.check_config
      validator = DemographicsConfigValidator.new
      validator.validate
    end
    
  end
end
