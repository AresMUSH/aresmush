module AresMUSH
  module Describe
    
    def self.emit_here_desc(client)
      desc = here_desc(client.location)
      client.emit_with_lines(desc)
    end
    
    def self.here_desc(loc_id)
      room = Room.find_by_id(loc_id)
      room.empty? ? "" : room_desc(room[0])
    end
    
    def self.room_desc(room)
      room_id = room["_id"]
      desc = "#{room["name"]}"
      desc << "\n#{room_id}"
      desc << "\n---------------------------"
      desc << "\n#{room["desc"]}"
      desc << "\n\nExits:"
      Rooms.exits_from(room_id).each do |e|
        dest = e["dest"].nil? ? "Nowhere" : Room.find_by_id(e["dest"])[0]["name"]
        desc << "\n   <#{e["name"]}> #{dest}"
      end
      desc << "\n\nPlayers:"
      Rooms.players(room_id).each do |p|
        desc << "\n   #{p["name"]}"
      end
      desc
    end
  end
end
