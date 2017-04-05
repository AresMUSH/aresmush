module AresMUSH
  module Roster
    def self.can_manage_roster?(actor)
      actor.has_permission?("manage_roster")
    end
    
    def self.create_or_update_roster(client, enactor, name, contact)
      ClassTargetFinder.with_a_character(name, client, enactor) do |model|
        Roster.add_to_roster(model, contact)
        client.emit_success t('roster.roster_updated')
      end
    end
    
    def self.add_to_roster(char, contact = nil)
      registry = char.get_or_create_roster_registry
      registry.update(contact: contact || Global.read_config("roster", "default_contact"))
      Login::Api.set_random_password(char)
    end
    
    def self.remove_from_roster(char)
      if (char.roster_registry)
        char.roster_registry.delete
      end
    end
  end
end