module AresMUSH
  module Describe
    def self.set_desc(model, desc)  
      Global.logger.debug("Setting desc: #{model.name} #{desc}")
      
      model.description = desc
      model.save!
    end
  
    def self.outfits
      Global.config['describe']['outfits']
    end
  
    def self.outfit(name)
      outfits[name]
    end
  end
end
