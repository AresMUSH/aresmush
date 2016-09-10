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
      elsif (char.has_any_role?(Global.read_config("describe", "roles", "can_desc_anything")))
        return true
      elsif (model.class == Room)
        return char.has_any_role?(Global.read_config("describe", "roles", "can_desc_places"))
      end
      return false
    end
    
    def self.get_desc_template(model, client)     
      if (model.class == Room)
        template = RoomTemplate.new(model, client)
      elsif (model.class == Character)
        template = CharacterTemplate.new(model, client)
      elsif (model.class == Exit)
        template = ExitTemplate.new(model, client)
      else
        raise "Invalid model type: #{model}"
      end
      template
    end
    
    def self.app_review(char)
      error = char.description.nil? ? t('chargen.not_set') : t('chargen.ok')
      Chargen::Interface.format_review_status t('describe.description_review'), error
    end
    
    def self.char_backup(char, client)
      template = Describe.get_desc_template(char, client)
      backup = template.build
      outfits = ""
      char.outfits.each do |name, desc|
        outfits << "%R%R%xh#{t('describe.outfit', :name => name)}%xn%r#{desc}"
      end
      backup << BorderedDisplay.text(outfits, t('describe.your_outfits'), false)
    end
    
  end
end
