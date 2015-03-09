module AresMUSH
  module Roster
    def self.can_manage_roster?(actor)
      actor.has_any_role?(Global.config['roster']['roles']['can_manage_roster'])
    end
    
    def self.create_or_update_roster(client, name, contact)
      ClassTargetFinder.with_a_character(name, client) do |model|
        Roster.add_to_roster(model, contact)
        client.emit_success t('roster.roster_updated')
      end
    end
  end
end