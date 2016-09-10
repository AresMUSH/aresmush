module AresMUSH
  module Groups
    class CompleteCensusTemplate < AsyncTemplateRenderer
      include TemplateFormatters
            
      attr_accessor :chars
      
      def initialize(chars, page, client)
        @chars = chars
        @page = page
        super client
      end
      
      def build
        census = @chars.sort_by { |c| c.name }.map { |c| char_entry(c) }
        BorderedDisplay.paged_list(census, @page, 25, t('groups.full_census_title'))
      end
      
      def char_entry(char)
        "#{char_name(char)} #{char_gender(char)} #{char_position(char)}"
      end
      
      def char_name(char)
        left(char.name, 20)
      end
      
      def char_gender(char)
        left(Demographics::Interface.gender(char), 15)
      end
      
      def char_position(char)
        char.groups["Position"]
      end
    end
  end
end
