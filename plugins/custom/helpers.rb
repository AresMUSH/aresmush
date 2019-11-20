module AresMUSH
  module Custom

    def self.add_storyteller(plot, char)
      if (!plot.storytellers.include?(char))
        plot.storytellers.add char
      end
    end

    def self.add_creature(scene, creature)
      if (!scene.creatures.include?(creature))
        scene.creatures.add creature
      end
    end

    def self.add_portal(scene, portal)
      if (!scene.portals.include?(portal))
        scene.portals.add portal
      end
    end

  end
end
