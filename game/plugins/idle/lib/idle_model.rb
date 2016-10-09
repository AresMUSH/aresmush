module AresMUSH
  class Character
    reference :idle_prefs, "AresMUSH::IdlePrefs"
    reference :idle_status, "AresMUSH::IdleStatus"
    
    def idled_out?
      self.idle_status && self.idle_status.idled_out
    end
  end
  
  class IdlePrefs < Ohm::Model
    include ObjectModel

    attribute :lastwill
    
    reference :character, "AresMUSH::Character"
  end
  
  class IdleStatus < Ohm::Model
    include ObjectModel
    
    attribute :status
    attribute :idled_out, DataType::Boolean
    
    index :idled_out
    
    reference :character, "AresMUSH::Character"
  end
end