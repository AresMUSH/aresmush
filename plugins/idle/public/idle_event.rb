module AresMUSH
  class CharIdledOutEvent
    attr_accessor :char_id, :idle_status
    
    def initialize(char_id, idle_status)
      self.char_id = char_id
      self.idle_status = idle_status
    end
    
    # NOTE!!! This event gets fired even when a character is being destroyed.
    # They'll probably already be destroyed before the event is handled, so don't 
    # try to access them.
    def is_destroyed?
      idle_status == "Destroy"
    end

  end
end