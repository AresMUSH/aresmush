module AresMUSH
  class Character
    reference :idle_status, "AresMUSH::IdleStatus"
    attribute :idle_warned
    
    before_delete :delete_idle_status
    
    def delete_idle_status
      self.idle_status.delete if self.idle_status
    end
    
    def get_or_create_idle_status
      status = self.idle_status
      if (!status)
        status = IdleStatus.create(character: self)
        self.update(idle_status: status)
      end
      status
    end
  end
  
  class Character
    attribute :idle_lastwill
  end
  
  class IdleStatus < Ohm::Model
    include ObjectModel
    
    attribute :status    
    reference :character, "AresMUSH::Character"
  end
end