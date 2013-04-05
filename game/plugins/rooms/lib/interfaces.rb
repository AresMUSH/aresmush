module AresMUSH
  module Rooms
    
    def self.room_emit(loc_id, message, all_clients)
      chars_in_room = all_clients.select { |c| c.char["location"] == loc_id }
      chars_in_room.each { |p| p.emit(message) } 
    end
    
    def self.chars(loc_id)
      Character.find("location" => loc_id)
    end
    
    def self.contents(loc_id)
      chars = Rooms.chars(loc_id)
      exits = Rooms.exits_from(loc_id)
      chars.concat(exits)
    end
    
    def self.find_visible_object(name, client)
      return client.char if (name.downcase == t("object.me"))

      loc_id = client.location
      return Room.find_one(loc_id) if (name.downcase == t("object.here"))
      
      contents = contents(loc_id)
      Room.notify_if_not_exatly_one(client) { contents.select { |c| c["name_upcase"] == name.upcase } }      
    end  
    
    def self.exits_from(loc_id)
      Room.find("source" => loc_id)
    end  
  end
end