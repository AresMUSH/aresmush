module AresMUSH
  module Rooms
    # TODO: Specs
    def self.find_one_visible(name, client)
      Room.ensure_only_one(client) { Room.find_all_visible(name, client) }
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