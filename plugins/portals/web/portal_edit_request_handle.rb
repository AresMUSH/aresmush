module AresMUSH
  module Portals
    class PortalEditRequestHandler
      def handle(request)
        Global.logger.debug "Edit Request: #{request.args}"
        portal = Portal.find_one_by_name(request.args[:id])
        Global.logger.debug "Edit Portal: #{portal}"
        Global.logger.debug "Edit PortalID: #{portal.id}"
        enactor = request.enactor

        if (!portal)
          return { error: t('webportal.not_found') }
        end

        # error = Website.check_login(request, true)
        # return error if error
        #
        # if (!enactor.is_approved?)
        #   return { error: t('dispatcher.not_allowed') }
        # end

        Global.logger.debug "Portal #{portal.id} (#{portal.name} Portal) edited by #{enactor.name}."

          gm_names = request.args[:gms] || []
          portal.gms.replace []
          gm_names.each do |gm|
            gm = Character.find_one_by_name(gm.strip)
            if (gm)
              if (!portal.gms.include?(gm))
                portal.gms.concat [gm]
              end
            end
          end

          portal.update(name: request.args[:name])
          portal.update(primary_school: request.args[:primary_school])
          portal.update(all_schools: request.args[:all_schools])
          portal.update(creatures: request.args[:creatures])
          portal.update(npcs: request.args[:npcs])
          portal.update(location: request.args[:location])
          portal.update(description: request.args[:description])
          portal.update(trivia: request.args[:trivia])
          portal.update(events: request.args[:events])
          {}
      end
    end
  end
end
