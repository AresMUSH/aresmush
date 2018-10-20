module AresMUSH
  module Demographics
    class CensusTypesCmd
      include CommandHandler
      
      def handle
        list = Demographics.census_types
        template = BorderedListTemplate.new list, t('demographics.census_types')
        client.emit template.render
      end
    end
  end
end
