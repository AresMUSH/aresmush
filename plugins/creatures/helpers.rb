module AresMUSH
  module Creatures

    def self.add_gm(creature, char)
      if (!creature.gms.include?(char))
        creature.gms.add char
      end
    end



  end
end
