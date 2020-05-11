module AresMUSH
  class ChannelMessage  < Ohm::Model
    include ObjectModel
    
    reference :character, "AresMUSH::Character"
    reference :channel, "AresMUSH::Channel"
    
    attribute :message
    
    def author_name
      self.character ? self.character.name : t('global.deleted_character')
    end
    
    def author
      self.character
    end
  end
end
