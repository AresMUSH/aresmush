module AresMUSH
  module Portals
    class PortalsRequestHandler
      def handle(request)


        portals = Portal.all.to_a

        portals.sort_by { |p| p.name }.map { |p| {
                  id: p.id,
                  name: p.name,
                  location_known: p.location_known,
                  short_desc: p.short_desc
                  # icon: Website.icon_for_char(p)
                }}



      end
    end
  end
end
