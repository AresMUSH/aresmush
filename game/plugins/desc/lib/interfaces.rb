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
      logger.debug("Setting desc: #{client} #{model["name"]} #{desc}")
      
      model["desc"] = desc
      model_class = AresModel.model_class(model)
      model_class.update(model)
      client.emit_success(t('describe.desc_set', :name => model["name"]))
    end
    
    def self.format_character_desc(char)      
      desc = ""
      desc << char["name"]
      desc << "\n"
      desc << "#{char["desc"]}"
      Formatter.perform_subs(desc)
    end
    
    def self.format_room_desc(room)
      room_id = room["_id"]
      desc = "%l3%r"
      desc << room["name"]
      desc << "\n#{room_id}"
      desc << "\n---------------------------"
      desc << "\n#{room["desc"]}"
      desc << "\n\nExits:"
      Rooms.exits_from(room_id).each do |e|
        dest = e["dest"].nil? ? "Nowhere" : Room.find_by_id(e["dest"])[0]["name"]
        desc << "\n   <#{e["name"]}> #{dest}"
      end
      desc << "\n\nCharacters:"
      Rooms.chars(room_id).each do |p|
        desc << "\n   #{p["name"]}"
      end
      desc << "%r%l4"
      Formatter.perform_subs(desc)
    end
  end
end
