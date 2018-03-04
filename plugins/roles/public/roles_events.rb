module AresMUSH
  class RoleChangedEvent
    attr_accessor :char_id, :role_removed
    def initialize(char, role_removed)
      self.char_id = char.id
      self.role_removed = role_removed
    end
  end
  
  class RoleDeletedEvent
    attr_accessor :role_id
    
    def initialize(role_id)
      self.role_id = role_id
    end
  end
end