module AresMUSH
  module Groups
    class GroupCensusTemplate < AsyncTemplateRenderer
      include TemplateFormatters
            
      attr_accessor :chars
      
      def initialize(chars, group_name, client)
        @chars = chars
        @group_name = group_name
        super client
      end
      
      def build_template
        
        group = Groups.get_group(@group_name)
        
        if (group.nil?)
          return BorderedDisplay.text t('groups.invalid_group_type')
        end
        
        title = t('groups.group_census_title', :name => @group_name)
        list = Groups.census_by { |c| c.groups[@group_name] }
        
        if (group['values'].nil?)
          list = list.first(20)
          title = t('groups.census_title_top_20', :name => @group_name)
        end
        
        BorderedDisplay.list list, title
      end      
    end
  end
end
