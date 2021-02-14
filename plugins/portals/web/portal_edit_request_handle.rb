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
              if (!portal.gms.include?(gm))
                Portals.add_gm(portal, gm)
              end
            end
          end

          creature_ids = request.args[:creatures] || []
          portal.creatures.replace []
          creature_ids.each do |creature|
            creature = Creature.find_one_by_name(creature.strip)
            if (creature)
              if (!portal.creatures.include?(creature))
                Portals.add_creature(portal, creature)
              end
            end
          end

          # if !request.args[:all_schools].blank?
          #   all_schools_names = request.args[:all_schools] || []
          #   portal.all_schools.replace []
          #   all_schools = []
          #   all_schools_names.each do |school|
          #     school_name = Global.read_config("schools", school, "name")
          #     id = Global.read_config("schools", school, "id")
          #     new_school = [{:name => school_name, :id => id}]
          #     all_schools.concat new_school
          #   end
          #   portal.update(all_schools: request.args[:all_schools])
          # end
          # school_name = request.args[:primary_school].to_s
          # id = Global.read_config("schools", request.args[:primary_school], "id")
          # primary_school = {:name => school_name, :id => id}

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
          Website.add_to_recent_changes('portal', t('portals.portal_updated', :name => portal.name), { id: portal.id }, enactor.name)
          {}
      end
    end
  end
end
