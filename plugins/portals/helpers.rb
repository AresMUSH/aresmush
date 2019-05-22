module AresMUSH
  module Portals

    def self.add_gm(portal, char)
      if (!portal.gms.include?(char))
        portal.gms.add char
      end
    end

    def self.add_creature(portal, creature)
      if (!portal.creatures.include?(creature))
        portal.creatures.add creature
      end
    end

    def self.add_school(portal, school_name, school_id)
        added_school = {:name => school_name, :id => school_id}
        portal.all_schools.concat [added_school]
    end

  end
end
