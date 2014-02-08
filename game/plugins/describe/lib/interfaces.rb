module AresMUSH
  module Describe
    
    def self.get_desc(model)
      if (model["type"] == "Room")
        renderer = RoomRenderer.new(model)
      elsif (model["type"] == "Character")
        renderer = CharRenderer.new(model)
      elsif (model["type"] == "Exit")
        renderer = ExitRenderer.new(model)
      else
        raise "Invalid model type: #{model["type"]}"
      end
      return renderer.render
    end
          
    def self.set_desc(model, desc)  
      Global.logger.debug("Setting desc: #{model["name"]} #{desc}")
      
      model["description"] = desc
      model_class = AresModel.model_class(model)
      model_class.update(model)
    end
    
  end
end
