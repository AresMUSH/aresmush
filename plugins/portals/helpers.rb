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

    def self.add_plot(portal, plot)
      if (!portal.plots.include?(plot))
        portal.plots.add plot
      end
    end

    def self.add_school(portal, school_name, school_id)
        added_school = {:name => school_name, :id => school_id}
        portal.all_schools.concat [added_school]
    end

    def self.build_image_path(portal, arg)
      return nil if !arg
      folder = Portals.portal_page_folder(portal)
      File.join folder, arg.downcase
    end

    def self.portal_page_folder(portal)
      Website::FilenameSanitizer.sanitize(portal.name.downcase)
    end

    def self.portal_page_files(portal)
      folder = Portals.portal_page_folder(portal)
      Dir[File.join(AresMUSH.website_uploads_path, "#{folder}/**")].sort
    end

  end
end
