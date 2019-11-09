module AresMUSH
  class Character
    reference :last_ic_location, "AresMUSH::Room"

    attribute :afk_message
    attribute :is_afk, :type => DataType::Boolean
    attribute :is_on_duty, :type => DataType::Boolean, :default => true
    attribute :is_playerbit, :type => DataType::Boolean
    attribute :is_npc, :type => DataType::Boolean
    
    def is_afk?
      is_afk
    end
    
    def is_npc?
      is_npc
    end
    
    def is_on_duty?
      is_on_duty
    end
    
    def is_playerbit?
      is_playerbit
    end
    
    def is_ic?
      self.room.room_type == "IC" || self.room.room_type == "RPR"
    end
    
    def status
      return "WEB" if Login.is_portal_only?(self)
      # AFK trumps all
      return "AFK" if self.is_afk?
      # Admins can be on duty or OOC
      return "ADM" if self.is_admin? && self.is_on_duty?
      return "OOC" if Status.can_be_on_duty?(self)
      # Playerbits are always OOC
      return "OOC" if self.is_playerbit
      # NPCs are always NPC
      return "NPC" if self.is_npc
      # New trumps room type
      return "NEW" if !self.is_approved? || self.is_beginner?
      # RP rooms show up as IC
      return "IC" if self.room.room_type == "RPR"
      # Otherwise use room type
      self.room.room_type
    end
    
    def afk_display
      self.is_afk? ? self.afk_message : ""
    end
  end
end