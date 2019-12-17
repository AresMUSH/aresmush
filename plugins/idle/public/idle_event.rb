module AresMUSH
  class CharIdledOutEvent
    attr_accessor :char_id, :idle_status
    
    def initialize(char_id, idle_status)
      self.char_id = char_id
      self.idle_status = idle_status
    end
  end
end