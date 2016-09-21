module AresMUSH
  class RolesChangedEvent
    attr_accessor :char
    def initialize(char)
      self.char = char
    end
  end
end