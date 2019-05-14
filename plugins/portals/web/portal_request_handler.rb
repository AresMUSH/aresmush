module AresMUSH
  module Portals
    class PortalRequestHandler
      def handle(request)
        Global.logger.debug "Request: #{request}"
        portal = Portal.find_one_by_name(request.args[:id])
        Global.logger.debug "Portal: #{portal}"
        enactor = request.enactor

        if (!portal)
          return { error: t('webportal.not_found') }
        end

        error = Website.check_login(request, true)
        return error if error

        {
          name: portal.name,
          primary_school: portal.primary_school,
          all_schools: portal.all_schools,
          creatures: portal.creatures,
          npcs: portal.npcs,
          gms: portal.gms.to_a,
          location: portal.location,
          description: portal.description,
          trivia: portal.trivia,
          events: portal.events,
          id: portal.id
        }
      end

    end
  end
end
