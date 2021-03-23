module AresMUSH
  module Portals
    class PortalEditRequestHandler
      def handle(request)
        portal = Portal.find_one_by_name(request.args[:id])
        enactor = request.enactor

        if (!portal)
          return { error: t('webportal.not_found') }
        end

        error = Website.check_login(request, true)
        return error if error

        if (!enactor.is_approved?)
          return { error: t('dispatcher.not_allowed') }
        end

        Global.logger.info "Portal #{portal.id} (#{portal.name} Portal) edited by #{enactor.name}. Request: #{request.args}"

          gm_names = request.args[:gms] || []
          portal.gms.replace []

          gm_names.each do |gm|
            gm = Character.find_one_by_name(gm.strip)
            if (gm)
              Portals.add_gm(portal, gm)
            end
          end

          plot_ids = request.args[:plots] || []
          portal.plots.replace []
          plot_ids.each do |plot|
            plot = Character.find_one_by_name(plot.strip)
            if (plot)
              Portals.add_plot(portal, plot)
            end
          end

          creature_ids = request.args[:creatures] || []
          portal.creatures.replace []
          creature_ids.each do |creature|
            creature = Creature.find_one_by_name(creature.strip)
            if (creature)
              Portals.add_creature(portal, creature)
            end
          end

          portal.update(all_schools: request.args[:all_schools])
          portal.update(primary_school: request.args[:primary_school])
          portal.update(name: request.args[:name])
          portal.update(pinterest: request.args[:pinterest].blank? ? nil : request.args[:pinterest])
          portal.update(other_creatures: request.args[:other_creatures].blank? ? nil : request.args[:other_creatures])
          portal.update(npcs: request.args[:npcs].blank? ? nil : request.args[:npcs])
          portal.update(location: request.args[:location].blank? ? nil : request.args[:location])
          portal.update(location_known: request.args[:location_known].to_bool)
          portal.update(latitude: request.args[:latitude].blank? ? nil : request.args[:latitude])
          portal.update(longitude: request.args[:longitude].blank? ? nil : request.args[:longitude])
          portal.update(description: request.args[:description].blank? ? nil : request.args[:description])
          portal.update(trivia: request.args[:trivia].blank? ? nil : request.args[:trivia])
          portal.update(events: request.args[:events].blank? ? nil : request.args[:events])
          portal.update(society: request.args[:society].blank? ? nil : request.args[:society])
          portal.update(rp_suggestions: request.args[:rp_suggestions].blank? ? nil : request.args[:rp_suggestions])
          portal.update(short_desc: request.args[:short_desc].blank? ? nil : request.args[:short_desc])
          banner_image = Portals.build_image_path(portal, request.args[:banner_image])
          profile_image = Portals.build_image_path(portal, request.args[:profile_image])
          gallery = (request.args[:image_gallery] || '').split.map { |g| g.downcase }
          portal.update(image_gallery: gallery)
          portal.update(banner_image: banner_image)
          portal.update(profile_image: profile_image)
          Website.add_to_recent_changes('portal', t('portals.portal_updated', :name => portal.name), { id: portal.id }, enactor.name)
          {}
      end
    end
  end
end
