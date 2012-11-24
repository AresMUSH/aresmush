module AresMUSH
    module Player
    
    extend AresModel
    
    def self.coll
      :players
    end    
    
    def self.set_model_fields(model)
      model["name_upcase"] = model["name"].upcase
      model
    end
    
  end
end
    