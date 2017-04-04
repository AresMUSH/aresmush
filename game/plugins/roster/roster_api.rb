module AresMUSH
  class Character  
    def on_roster?
      !!roster_registry
    end
  end
  
  module Roster
    module Api
      def self.add_to_roster(char, contact = nil)
        Roster.add_to_roster(char, contact)
      end
      
      def self.remove_from_roster(char)
        Roster.remove_from_roster(char)
      end
    end
  end
end