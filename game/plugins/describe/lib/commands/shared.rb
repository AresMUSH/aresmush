module AresMUSH
  module Describe
    def self.set_desc(model, desc)  
      Global.logger.debug("Setting desc: #{model.name} #{desc}")
      
      model.description = desc
      model.save!
    end
    
    def self.can_describe?(char, model)
      if (char == model)
        return true
      elsif (char.has_any_role?(Global.config['describe']['roles']['can_desc_anything']))
        return true
      elsif (model.class == Room)
        return char.has_any_role?(Global.config['describe']['roles']['can_desc_places'])
      end
      return false
    end
  end
end
