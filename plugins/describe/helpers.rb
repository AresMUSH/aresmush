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
    
    def self.create_or_update_desc(model, description, type = :current)
      desc = model.descs_of_type(type).first
    
      if (!desc)
        desc = model.create_desc(type,  description)
      else
        desc.update(description: description)
      end
    end
    
    def self.is_reserved_desc_type?(type)
      [ 'current', 'short', 'outfit' ].include?(type)
    end
        
  end
end
