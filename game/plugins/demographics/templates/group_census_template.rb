module AresMUSH
  module Demographics
    class GroupCensusTemplate < ErbTemplateRenderer
            
      attr_accessor :name, :group
      
      def initialize(group, name)
        @name = name
        @group = group
        super File.dirname(__FILE__) + "/group_census.erb"
      end
      
      def chars
        Idle::Api.active_chars.map { |c| c.name }
      end
      
      def title
        is_freeform ? t('demographics.census_title_top_20', :name => self.name) : 
            t('demographics.group_census_title', :name => self.name)
      end
      
      def census
        census = Demographics.census_by { |c| c.group(self.name) ? c.group(self.name).value : nil }
        is_freeform ? census.first(20) : census
      end
      
      def is_freeform
        !self.group['values']
      end
      
    end
  end
end
