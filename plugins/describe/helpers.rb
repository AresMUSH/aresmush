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
    
    def self.format_glance_output(char)
      glance_format = Global.read_config("describe", "glance_format")
      glance_args = {
        name: char.name, 
        age: char.age,
        gender_noun: Demographics.gender_noun(char) }
      Demographics.visible_demographics(char, @enactor).each do |k|
        next if k == 'birthdate'
        glance_args[k.downcase.to_sym] = (char.demographic(k) || "-").downcase
        glance_args["#{k.downcase}_title".to_sym] = (char.demographic(k) || "-").titlecase
      end
      output = (glance_format % glance_args) || ""
      output
    end
  end
end
