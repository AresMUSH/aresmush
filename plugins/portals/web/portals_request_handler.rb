module AresMUSH
  module Portals
    class PortalsRequestHandler
      def handle(request)


        portals = Portal.all.to_a

        portals.sort_by { |c| c.name }.map { |c| {
                  id: c.id,
                  name: c.name,
                  location_known: c.location_known
                  # icon: Website.icon_for_char(c)
                }}



      end
    end
  end
end
