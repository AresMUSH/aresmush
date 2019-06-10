module AresMUSH
  module Demographics
    class GroupDetailTemplate < ErbTemplateRenderer
      
      attr_accessor :group, :name
      
      def initialize(name, group)
        @group = group
        @name = name
        super File.dirname(__FILE__) + "/group_detail.erb"
      end      
      
      def description
        self.group['desc']
      end
      
      def wiki
        page = self.group['wiki']
        if (!page.blank?)
          "#{Game.web_portal_url}/wiki/#{page}"
        end
      end
      
      def values
        self.group['values'].sort
      end
      
    end
  end
end