module AresMUSH
  class Character
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
      self.room.room_type == "IC"
    end
    
    def status
      # AFK trumps all
      return "AFK" if self.is_afk?
      # Admins can be on duty or OOC
      return "ADM" if self.is_admin? && self.is_on_duty?
      return "OOC" if Status.can_be_on_duty?(self)
      # Playerbits are always OOC
      return "OOC" if self.is_playerbit
      # New trumps room type
      return "NEW" if !self.is_approved?
      # Otherwise use room type
      self.room.room_type
    end
    
    def afk_display
      self.is_afk? ? self.afk_message : ""
    end
  end

  module Status
    module Api
      def self.status_color(status)
        Status.status_color(status)
      end
    
      def self.is_idle?(client)
        Status.is_idle?(client)
      end
    end
  end  
end