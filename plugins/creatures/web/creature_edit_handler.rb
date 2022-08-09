module AresMUSH
  module Creatures
    class CreatureEditRequestHandler
      def handle(request)
        creature = Creature.find_one_by_name(request.args[:id])
        enactor = request.enactor

        if (!creature)
          return { error: t('webcreature.not_found') }
        end

        error = Website.check_login(request, true)
        return error if error

        if (request.args[:name].blank? || request.args[:short_desc].blank?)
          return { error: t('webportal.missing_required_fields') }
        end

        if (!enactor.is_approved?)
          return { error: t('dispatcher.not_allowed') }
        end

        Global.logger.debug "Creature #{creature.id} (#{creature.name}) edited by #{enactor.name}. Request: #{request.args}"

          gm_names = request.args[:gms] || []
          creature.gms.replace []

          gm_names.each do |gm|
            gm = Character.find_one_by_name(gm.strip)
            if (gm)
              if (!creature.gms.include?(gm))
                Creatures.add_gm(creature, gm)
              end
            end
          end

          plot_ids = request.args[:plots] || []
          creature.plots.replace []

          plot_ids.each do |plot|
            plot = Plot.find_one_by_name(plot.strip)
            if (plot)
              Creatures.add_plot(portal, plot)
            end
          end

          portal_ids = request.args[:portals] || []
          creature.portals.replace []

          portal_ids.each do |portal|
            portal = Portal.find_one_by_name(portal.strip)
            if (portal)
              Creatures.add_portal(creature, portal)
            end
          end

          # if !request.args[:major_school].blank?
          #   major_school_name = request.args[:major_school]
          #   id = Global.read_config("schools", request.args[:major_school], "id")
          #   major_school = {:name => major_school_name, :id => id}
          #   creature.update(major_school: major_school)
          # end
          #
          # if !request.args[:minor_school].blank?
          #   minor_school_name = request.args[:minor_school]
          #   id = Global.read_config("schools", request.args[:minor_school], "id")
          #   minor_school = {:name => minor_school_name, :id => id}
          #   creature.update(minor_school: minor_school)
          # end
          sapient = (request.args[:sapient] || "").to_bool

          creature.update(minor_school: request.args[:minor_school])
          creature.update(major_school: request.args[:major_school])
          creature.update(name: request.args[:name])
          creature.update(pinterest: request.args[:pinterest].blank? ? nil : request.args[:pinterest])
          creature.update(found: request.args[:found].blank? ? nil : request.args[:found])
          creature.update(sapient: sapient)
          creature.update(language: request.args[:language].blank? ? nil : request.args[:language])
          creature.update(traits: request.args[:traits].blank? ? nil : request.args[:traits])
          creature.update(society: request.args[:society].blank? ? nil : request.args[:society])
          creature.update(short_desc: request.args[:short_desc].blank? ? nil : request.args[:short_desc])
          creature.update(magical_abilities: request.args[:magical_abilities].blank? ? nil : request.args[:magical_abilities])
          creature.update(events: request.args[:events].blank? ? nil : request.args[:events])
          banner_image = Creatures.build_image_path(creature, request.args[:banner_image])
          profile_image = Creatures.build_image_path(creature, request.args[:profile_image])
          gallery = (request.args[:image_gallery] || '').split.map { |g| g.downcase }
          creature.update(image_gallery: gallery)
          creature.update(banner_image: banner_image)
          creature.update(profile_image: profile_image)

          Website.add_to_recent_changes('creature', t('creatures.creature_updated', :name => creature.name), { id: creature.id }, enactor.name)

          {}
      end
    end
  end
end
