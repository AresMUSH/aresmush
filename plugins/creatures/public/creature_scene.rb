module AresMUSH

  class Scene < Ohm::Model
    set :creatures, "AresMUSH::Creature"

    def self.creature_scenes(creature)
      Scene.all.select { |s| s.shared && s.creatures.include?(creature) }
    end
  end
end