module AresMUSH
  module Describe
    def self.set_desc(model, desc)  
      Global.logger.debug("Setting desc: #{model.name} #{desc}")
      
      model.description = desc
      model.save
    end
    
    def self.can_describe?(char, model)
      if (char == model)
        return true
      elsif (char.has_any_role?(Global.read_config("describe", "roles", "can_desc_anything")))
        return true
      elsif (model.class == Room)
        return char.has_any_role?(Global.read_config("describe", "roles", "can_desc_places"))
      end
      return false
    end
    
    def self.get_desc_template(model, enactor)     
      if (model.class == Room)
        template = RoomTemplate.new(model, enactor)
      elsif (model.class == Character)
        template = CharacterTemplate.new(model)
      elsif (model.class == Exit)
        template = ExitTemplate.new(model)
      else
        raise "Invalid model type: #{model}"
      end
      template
    end
    
    def self.app_review(char)
      error = !char.description ? t('chargen.not_set') : t('chargen.ok')
      Chargen::Api.format_review_status t('describe.description_review'), error
    end
    
    def self.rooms_with_scenes
      Room.all.select { |r| !r.sceneset.empty? }
    end
    
  end
end
