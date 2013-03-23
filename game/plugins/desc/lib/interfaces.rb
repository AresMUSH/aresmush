module AresMUSH
  module Describe
    def self.get_desc(model)
      format_method = "format_#{model["type"]}_desc".downcase
      if (self.respond_to?(format_method))
        return self.send(format_method,model)
      end
      model["desc"]
    end
    
    def self.set_desc(client, model, desc)  
      model["desc"] = desc
      model_class = AresModel.model_class(model)
      model_class.update(model)
      client.emit_success(t('describe.desc_set', :name => model["name"]))
    end
    
    def self.format_player_desc(player)      
      desc = ""
      desc << player["name"]
      desc << "\n"
      desc << player["desc"]
      desc.perform_subs(player)
    end
    
    def self.format_room_desc(room)
      room_id = room["_id"]
      desc = ""
      desc << room["name"]
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
      desc.perform_subs(room)
    end
  end
end
