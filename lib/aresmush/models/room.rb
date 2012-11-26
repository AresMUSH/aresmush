module AresMUSH
  module Room
    extend AresModel
    
    def self.coll
      :rooms
    end
        
    def self.custom_model_fields(model)
      model["name_upcase"] = model["name"].upcase
      model["type"] = "Room"
      model
    end
    
    def self.find_visible(name, player)
      if (name == "me")
        [player]
      elsif (name == "here")
        Room.find_by_id(player["location"])
      # TODO - Add searches for exits and contents
      # TODO - Add aliases.
      end
    end
    
  end
end
