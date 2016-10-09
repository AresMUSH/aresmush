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
    end
  end
end