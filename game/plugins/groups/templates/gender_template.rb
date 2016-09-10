module AresMUSH
  module Groups
    class GenderCensusTemplate < AsyncTemplateRenderer
      include TemplateFormatters
            
      attr_accessor :chars
      
      def initialize(chars, client)
        @chars = chars
        super client
      end
      
      def build
        title = t('groups.gender_census_title')
        list = Groups.census_by { |c| Demographics::Interface.gender(c) }
        BorderedDisplay.list list, title
      end      
    end
  end
end
