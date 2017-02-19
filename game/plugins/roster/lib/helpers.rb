module AresMUSH
  module Roster
    def self.can_manage_roster?(actor)
      actor.has_any_role?(Global.read_config("roster", "can_manage_roster"))
    end
    
    def self.create_or_update_roster(client, enactor, name, contact)
      ClassTargetFinder.with_a_character(name, client, enactor) do |model|
        Roster.add_to_roster(model, contact)
        client.emit_success t('roster.roster_updated')
      end
    end
    
    def self.add_to_roster(char, contact = nil)
      registry = char.get_or_create_roster_registry
      registry.update(contact: contact)
    end
  end
end