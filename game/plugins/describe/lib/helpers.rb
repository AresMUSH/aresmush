module AresMUSH
  module Describe
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
      error = !char.current_desc ? t('chargen.not_set') : t('chargen.ok')
      Chargen::Api.format_review_status t('describe.description_review'), error
    end
    
    def self.rooms_with_scenes
      Room.all.select { |r| !!r.scene_set }
    end
    
    def self.update_current_desc(char, text)
      desc = char.current_desc
    
      if (!desc)
        desc = char.create_desc(:current, text)
      end
      desc.update(description: text)
    end
  end
end
