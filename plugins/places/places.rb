$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Places
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("places", "shortcuts")
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
       case cmd.root
       when "place"
         case cmd.switch
         when nil
           return PlacesCmd
         when "create"
           return PlaceCreateCmd
         when "emit"
           return PlaceEmitCmd
         when "delete"
           return PlaceDeleteCmd
         when "join"
           return PlaceJoinCmd
         when "leave"
           return PlaceLeaveCmd
         when "rename"
           return PlaceRenameCmd
         end
       end
    end

    def self.get_event_handler(event_name) 
      case event_name
      when "CronEvent"
        return CronEventHandler
      end
      nil
    end
    
    def self.get_web_request_handler(request)
      case request.cmd
      when "changePlace"
        return ChangePlaceRequestHandler   
      when "viewPlaces" 
        return ViewPlacesRequestHandler
      when "leavePlace"
        return LeavePlaceRequestHandler
      end
      nil
    end
    
    def self.check_config
      validator = PlacesConfigValidator.new
      validator.validate
    end
  end
end
