module AresMUSH
  module Magic
    class GetSchoolsRequestHandler
      def handle(request)
        all_schools = Global.read_config("schools")
        all_schools = all_schools.map {|k, v| {name: v['name'], id: v['id']}}
        schools = []
        all_schools.each do |s|
           schools = schools.concat [s[:name]]
        end

        return schools
      end
    end
  end
end
