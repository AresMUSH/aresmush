module AresMUSH
  module Describe
    def self.get_desc(model, client)     
      if (model.class == Room)
        renderer = Describe.room_renderer
      elsif (model.class == Character)
        renderer = Describe.char_renderer
      elsif (model.class == Exit)
        renderer = Describe.exit_renderer
      else
        raise "Invalid model type: #{model}"
      end
      renderer.render(model, client)
    end
    
    def self.app_review(char)
      error = char.description.nil? ? t('chargen.not_set') : t('chargen.ok')
      Chargen.display_review_status t('describe.description_review'), error
    end
  end
end
