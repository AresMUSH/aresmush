module AresMUSH
  module Rooms
    def self.find_one_visible(name, client)
      all_visible = Room.find_all_visible(name, client)
      client.emit_failure("TODO-I don't see that here") and return nil if all_visible.empty?
      client.emit_failure("TODO-I can't tell which one you mean") and return nil if all_visible.count > 1
      return all_visible[0]
    end

    def self.find_all_visible(name, client)
      # TODO - Localize these keywords
      if (name == "me")
        [client.player]
      elsif (name == "here")
        Room.find_by_id(client.player["location"])
        # TODO - Add searches for exits and contents
        # TODO - Add aliases.
      end
    end

    def self.desc_for_id(room_id)
      room = Room.find_by_id(room_id)
      room.empty? ? "" : Describe.room_desc(room[0])
    end
    
    def self.emit_current_desc(client)
      loc = client.player["location"]  
      desc = Rooms.desc_from_id(loc)     
      client.emit_lines(desc)
    end
  end
end