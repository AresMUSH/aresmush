module AresMUSH
  class Character
    field :last_ic_location_id, :type => BSON::ObjectId
    field :afk_message, :type => String
    field :is_afk, :type => Boolean
    field :is_on_duty, :type => Boolean, :default => true
    field :is_playerbit, :type => Boolean    
    
    def is_afk?
      is_afk
    end
    
    def is_on_duty?
      is_on_duty
    end
    
    def is_playerbit?
      is_playerbit
    end
    
    def is_ic?
      Rooms::Api.room_type(self.room) == "IC"
    end
    
    def status
      # AFK trumps all
      return "AFK" if self.is_afk?
      # Admins can be on duty or OOC
      return "ADM" if Roles::Api.is_admin?(self) && self.is_on_duty?
      return "OOC" if Status.can_be_on_duty?(self)
      # Playerbits are always OOC
      return "OOC" if self.is_playerbit
      # New trumps room type
      return "NEW" if !self.is_approved
      # Otherwise use room type
      Rooms::Api.room_type(self.room)
    end
  end
end