module AresMUSH
  class RoleChangedEvent
    attr_accessor :char
    def initialize(char)
      self.char = char
    end
  end
  
  class RoleDeletedEvent
    attr_accessor :role_id
    
    def initialize(role_id)
      self.role_id = role_id
    end
  end
end