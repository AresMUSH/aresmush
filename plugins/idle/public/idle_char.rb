module AresMUSH
  class Character
    attribute :idle_warned
    attribute :idle_lastwill
    attribute :idle_state
    attribute :idle_notes
    attribute :roster_contact
    attribute :roster_notes
    attribute :roster_restricted, :type => DataType::Boolean
    attribute :roster_played, :type => DataType::Boolean
    
    def idled_out?
      !!self.idle_state
    end
    
    def on_roster?
      self.idle_state == "Roster"
    end
    
    def idled_out_reason
      self.idle_state
    end
    
    def is_active?
      return false if self.idled_out?
      return false if self.is_admin?
      return false if self.is_playerbit?
      return false if self.is_guest?
      return false if self.is_npc?
      return false if self.on_roster?
      return true
    end
  end
end