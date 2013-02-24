module AresMUSH
  module Describe     
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
