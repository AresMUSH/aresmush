module AresMUSH
  module Rooms
    
    def self.room_emit(loc_id, message, all_clients)
      players_in_room = all_clients.select { |c| c.player["location"] == loc_id }
      players_in_room.each { |p| p.emit(message) } 
    end
    
    def self.players(loc_id)
      Player.find("location" => loc_id)
    end
    
    def self.contents(loc_id)
      players = Rooms.players(loc_id)
      exits = Rooms.exits_from(loc_id)
      players.concat(exits)
    end
    
    def self.find_visible_object(name, client)
      return client.player if (name == t("object.me"))

      loc_id = client.location
      return Room.find_one(loc_id) if (name == t("object.here"))
      
      contents = contents(loc_id)
      Room.notify_if_not_exatly_one(client) { contents.select { |c| c["name"] == name } }      
    end  
    
    def self.exits_from(loc_id)
      Room.find("source" => loc_id)
    end  
  end
end