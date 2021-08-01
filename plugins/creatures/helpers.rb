module AresMUSH
  module Creatures

    def self.add_creature_to_scene(scene, creature)
      if (!scene.creatures.include?(creature))
        scene.creatures.add creature
      end
    end

    def self.add_gm(creature, char)
      if (!creature.gms.include?(char))
        creature.gms.add char
      end
    end

    def self.add_plot(creature, plot)
      if (!creature.plots.include?(plot))
        creature.plots.add plot
      end
    end

    def self.add_portal(creature, portal)
      if (!creature.portals.include?(portal))
        creature.portals.add portal
      end
      Global.logger.debug "Portals: #{creature.portals.to_a}"
    end

    def self.build_image_path(creature, arg)
      return nil if !arg
      folder = Creatures.creature_page_folder(creature)
      File.join folder, arg.downcase
    end

    def self.creature_page_folder(creature)
      Website::FilenameSanitizer.sanitize(creature.name.downcase)
    end

    def self.creature_page_files(creature)
      folder = Creatures.creature_page_folder(creature)
      Dir[File.join(AresMUSH.website_uploads_path, "#{folder}/**")].sort
    end

  end
end
