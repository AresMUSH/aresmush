module AresMUSH
  module Portals
    class GetSchoolsRequestHandler
      def handle(request)
        schools = Global.read_config("schools")
        schools.map {|k, v| {name: v['name'], id: v['id']}}
      end
    end
  end
end
