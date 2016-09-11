module AresMUSH
  module Roster
    module Interface
      def self.add_to_roster(char, contact = nil)
        Roster.add_to_roster(char, contact)
      end
      
      def self.on_roster?(char)
        char.on_roster?
      end
    end
  end
end