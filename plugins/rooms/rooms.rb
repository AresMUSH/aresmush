$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Rooms
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("rooms", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
    
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "area"
        return AreaCmd
      when "build"
        return BuildCmd
      when "foyer"
        return FoyerCmd
      when "go"
        return GoCmd
      when "grid"
        return GridCmd
      when "home"
        case cmd.switch
        when "set"
          return HomeSetCmd
        when nil
          return HomeCmd
        end
      when "icstart"
        return ICStartCmd
      when "link"
        return LinkCmd
      when "lock"
        if (cmd.args)
          return LockCmd
        else
          return LockHereCmd
        end
      when "meetme"
        case cmd.switch
        when "join", "bring"
          return MeetmeGoCmd
        when nil
          return MeetmeInviteCmd
        end
      when "open"
        return OpenCmd
      when "out"
        return OutCmd
      when "owner"
        return OwnerCmd
      when "rooms"
        return RoomsCmd
      when "roomtype"
        return RoomTypeCmd
      when "teleport"
        return TeleportCmd
      when "unlink"
        return UnlinkCmd
      when "unlock"
        if (cmd.args)
          return LockCmd
        else
          return UnlockHereCmd
        end
      when "work"
        case cmd.switch
        when "set"
          return WorkSetCmd
        when nil
          return WorkCmd
        end
      end
      
      nil
    end
    
    def self.get_event_handler(event_name) 
      case event_name
      when "CharConnectedEvent"
        return CharConnectedEventHandler
      when "CharDisconnectedEvent"
        return CharDisconnectedEventHandler
      when "CronEvent"
        return CronEventHandler
      end
      nil
    end
    
    def self.get_web_request_handler(request)
      case request.cmd
      when "locations"
        return LocationsRequestHandler
      when "location"
        return LocationRequestHandler
      end
      nil
    end
  end
end
