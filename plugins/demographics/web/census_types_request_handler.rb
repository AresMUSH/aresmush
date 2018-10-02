module AresMUSH
  module Demographics
    class CensusTypesRequestHandler
      def handle(request)
        Demographics.census_types
      end
    end
  end
end