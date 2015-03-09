module AresMUSH
  module Roster
    def self.add_to_roster(char, contact = nil)
      registry = char.roster_registry || RosterRegistry.new
      registry.character = char
      registry.contact = contact
      registry.save!
    end
  end
end