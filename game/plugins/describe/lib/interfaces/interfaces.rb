module AresMUSH
  module Describe
    def self.get_desc(model)     
      if (model.class == Room)
        renderer = Describe.room_renderer
      elsif (model.class == Character)
        renderer = Describe.char_renderer
      elsif (model.class == Exit)
       renderer = Describe.exit_renderer
      else
        raise "Invalid model type: #{model}"
      end
      renderer.render(model)
    end
  end
end
