module AresMUSH
  module Describe
    
    def self.get_desc(model)     
      if (model.class == Room)
        renderer = RendererFactory.room_renderer
      elsif (model.class == Character)
        renderer = RendererFactory.char_renderer
      elsif (model.class == Exit)
        renderer = RendererFactory.exit_renderer
      elsif (model.class == Client)
        renderer =  RendererFactory.char_renderer
        model = model.char
      else
        raise "Invalid model type: #{model}"
      end
      return renderer.render(model)
    end
          
    # TODO - Add model extensions
    def self.set_desc(model, desc)  
      Global.logger.debug("Setting desc: #{model.name} #{desc}")
      
      model.description = desc
      model.save!
    end
  end
end
