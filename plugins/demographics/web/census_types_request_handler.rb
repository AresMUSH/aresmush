module AresMUSH
  module Demographics
    class CensusTypesRequestHandler
      def handle(request)
        types = Demographics.all_groups.keys.map { |t| t.titlecase }
        types << 'Gender'
        if (Ranks.is_enabled?)
          types << 'Rank'
        end
        types.sort
      end
    end
  end
end