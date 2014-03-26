module AresMUSH
  module Describe
    def self.get_desc(model)     
      if (model.class == Room)
        renderer = RendererFactory.room_renderer
      elsif (model.class == Character)
        renderer = RendererFactory.char_renderer
      elsif (model.class == Exit)
       renderer = RendererFactory.exit_renderer
      else
        raise "Invalid model type: #{model}"
      end
      renderer.render(model)
    end
  end
end
