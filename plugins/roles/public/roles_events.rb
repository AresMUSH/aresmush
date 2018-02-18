module AresMUSH
  class RoleChangedEvent
    attr_accessor :char_id
    def initialize(char)
      self.char_id = char.id
    end
  end
  
  class RoleDeletedEvent
    attr_accessor :role_id
    
    def initialize(role_id)
      self.role_id = role_id
    end
  end
end