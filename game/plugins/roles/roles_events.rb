module AresMUSH
  class RolesChangedEvent
    attr_accessor :char
    def initialize(char)
      self.char = char
    end
  end
  
  puts "LOADED"
  class RolesDeletedEvent
    attr_accessor :role_id
    
    def initialize(role_id)
      self.role_id = role_id
    end
  end
end