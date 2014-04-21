module AresMUSH
  module Roles
    class RolesChangedEvent
      attr_accessor :char
      def initialize(char)
        self.char = char
      end
    end
  end
end