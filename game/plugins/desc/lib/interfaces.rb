module AresMUSH
  module Describe
    
    def self.emit_here_desc(client)
      desc = here_desc(client.player)
      client.emit_with_lines(desc)
    end
    
    def self.here_desc(player)
      loc = player["location"]        
      room = Room.find_by_id(loc)
      room.empty? ? "" : room_desc(room[0])
    end
    
    def self.room_desc(room)
      desc = "#{room["name"]}(#{room["_id"]})\n#{room["desc"]}"
      Exit.exits_from(room).each do |e|
        dest = e["dest"].nil? ? "Nowhere" : Room.find_by_id(e["dest"])[0]["name"]
        desc << "\n\<#{e["name"]}> #{dest}"
      end
      desc
    end
  end
end
