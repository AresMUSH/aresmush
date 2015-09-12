module AresMUSH
  module Describe
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
      Chargen.display_review_status t('describe.description_review'), error
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
