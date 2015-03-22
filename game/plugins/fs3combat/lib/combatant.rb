module AresMUSH
  module FS3Combat
    class Combatant
      attr_accessor :name, :name_upcase, :combatant_type, :char
      
      def initialize(name, combatant_type, char = nil)
        self.name = name.titleize
        self.name_upcase = name.upcase
        self.combatant_type = combatant_type
        self.char = char
      end
      
      def client
        self.char ? self.char.client : nil
      end
      
      def is_npc?
        !self.char.nil?
      end
    end
  end
end