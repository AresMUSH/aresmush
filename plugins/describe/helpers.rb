module AresMUSH
  module Describe
    def self.can_describe?(char, model)
      if (char == model)
        return true
      elsif (char.has_permission?("desc_anything"))
        return true
      elsif (model.class == Room || model.class == Exit)        
        return model.owned_by?(char) || char.has_permission?("desc_places")
      end
      return false
    end
    
    def self.is_reserved_desc_type?(type)
      [ 'current', 'short', 'outfit' ].include?(type)
    end
  end
end
