module AresMUSH
  module Creatures

    def self.add_gm(creature, char)
      if (!creature.gms.include?(char))
        creature.gms.add char
      end
    end

    def self.add_portal(creature, portal)
      if (!creature.portals.include?(portal))
        creature.portals.add portal
      end
      Global.logger.debug "Portals: #{creature.portals.to_a}"
    end



  end
end
