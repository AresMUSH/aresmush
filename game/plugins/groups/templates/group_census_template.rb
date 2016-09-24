module AresMUSH
  module Groups
    class GroupCensusTemplate < ErbTemplateRenderer
      include TemplateFormatters
            
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
        is_freeform ? t('groups.census_title_top_20', :name => self.name) : 
            t('groups.group_census_title', :name => self.name)
      end
      
      def census
        census = Groups.census_by { |c| c.groups[self.name] }
        is_freeform ? census.first(20) : census
      end
      
      def is_freeform
        !self.group['values']
      end
      
    end
  end
end
