module AresMUSH
  module Portals
    class PortalEditRequestHandler
      def handle(request)

        portal = Portal.find_one_by_name request.args[:id]
        Global.logger.debug "Portal: #{portal}"
        # Global.logger.debug "PortalID: #{portal.id}"
        enactor = request.enactor

        if (!portal)
          return { error: t('webportal.not_found') }
        end

        error = Website.check_login(request, true)
        return error if error

        if (!enactor.is_approved?)
          return { error: t('dispatcher.not_allowed') }
        end

        Global.logger.debug "Portal #{portal.id} edited by #{enactor.name}."


          portal.update(name: request.args[:name])
          portal.update(primary_school: request.args[:primary_school])
          portal.update(all_schools: prequest.args[:all_schools])
          portal.update(creatures: request.args[:creatures])
          portal.update(npcs: request.args[:npcs])
          portal.update(gms: request.args[:gms])
          portal.update(location: request.args[:location])
          portal.update(description: request.args[:description])
          portal.update(trivia: request.args[:trivia])
          portal.update(events: request.args[:events])
          {}
      end
    end
  end
end
