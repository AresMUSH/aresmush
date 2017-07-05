module AresMUSH
  module Describe
    def self.can_describe?(char, model)
      if (char == model)
        return true
      elsif (char.has_permission?("desc_anything"))
        return true
      elsif (model.class == Room)        
        return model.owned_by?(char) || char.has_permission?("desc_places")
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
    
    def self.create_or_update_desc(model, description, type = :current)
      desc = model.descs_of_type(type).first
    
      if (!desc)
        desc = model.create_desc(type,  description)
      else
        desc.update(description: description)
      end
    end
    
    def self.app_review(char)
      has_desc = char.current_desc && !char.current_desc.description.to_s.empty?
      error = has_desc ? t('chargen.ok') : t('chargen.not_set')
      Chargen.format_review_status t('describe.description_review'), error
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
