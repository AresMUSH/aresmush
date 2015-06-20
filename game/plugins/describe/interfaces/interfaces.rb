module AresMUSH
  module Describe
    def self.get_desc(model, client)     
      if (model.class == Room)
        template = RoomTemplate.new(model, client)
      elsif (model.class == Character)
        template = CharacterTemplate.new(model, client)
      elsif (model.class == Exit)
        template = ExitTemplate.new(model, client)
      else
        raise "Invalid model type: #{model}"
      end
      template.display
    end
    
    def self.app_review(char)
      error = char.description.nil? ? t('chargen.not_set') : t('chargen.ok')
      Chargen.display_review_status t('describe.description_review'), error
    end
    
    def self.char_backup(char, client)
      backup = Describe.get_desc(char, client)
      char.outfits.each do |name, desc|
        backup << "%R%r%xh#{t('describe.outfit', :name => name)}%xn%r#{desc}"
      end
      backup
    end
  end
end
