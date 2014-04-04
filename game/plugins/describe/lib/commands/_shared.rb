module AresMUSH
  module Describe
    def self.set_desc(model, desc)  
      Global.logger.debug("Setting desc: #{model.name} #{desc}")
      
      model.description = desc
      model.save!
    end
    
    def self.can_describe?(client, model)
      actor = client.char
      if (actor == model)
        return true
      elsif (actor.has_any_role?(Global.config['describe']['roles']['can_desc_anything']))
        return true
      elsif (model.class == Room)
        return actor.has_any_role?(Global.config['describe']['roles']['can_desc_places'])
      end
      return false
    end
  end
end
