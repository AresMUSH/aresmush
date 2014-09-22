module AresMUSH
  class Character
    field :last_ic_location_id, :type => Moped::BSON::ObjectId
    field :afk_message, :type => String
    field :is_afk, :type => Boolean
    field :is_approved, :type => Boolean
    field :is_on_duty, :type => Boolean
    
    def is_approved?
      is_approved
    end
    
    def status
      # AFK trumps all
      return "AFK" if self.is_afk
      # Admins can be on duty or OOC
      return "ADM" if self.is_on_duty
      return "OOC" if Status.can_manage_status?(self)
      # New trumps regular status
      return "NEW" if !self.is_approved
      # Otherwise use room type
      self.room.room_type
    end
  end
end