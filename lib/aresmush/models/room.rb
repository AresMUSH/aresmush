module AresMUSH
  module Room
    extend AresModel
    
    def self.coll
      :rooms
    end
        
    def self.set_model_fields(model)
      model["name_upcase"] = model["name"].upcase
      model
    end
  end
end
