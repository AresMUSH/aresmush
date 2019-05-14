module AresMUSH
  module Portals
    class PortalRequestHandler
      def handle(request)
        portal = Portal.find_one_by_name request.args[:portal]
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
          gms: portal.gms,
          location: portal.location,
          description: portal.description,
          trivia: portal.trivia,
          events: portal.events
        }
      end

    end
  end
end
