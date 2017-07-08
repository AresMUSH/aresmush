module AresMUSH
  class Character
    attribute :idle_warned
    attribute :idle_lastwill
    attribute :idle_state
    attribute :roster_contact
    attribute :roster_notes
    attribute :roster_restricted, :type => DataType::Boolean
    
    def idled_out?
      !!self.idle_state
    end
    
    def on_roster?
      self.idle_state == "Roster"
    end
    
    def idled_out_reason
      self.idle_state
    end
  end
end