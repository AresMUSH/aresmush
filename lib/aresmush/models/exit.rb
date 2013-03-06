module AresMUSH
  module Exit
    extend AresModel
    
    def self.coll
      :exits
    end

    def self.custom_model_fields(model)
      model["name_upcase"] = model["name"].upcase
      model["type"] = "Exit"
      model
    end    
  end
end
