module AresMUSH
  module Help
    class HelpListTemplate < ErbTemplateRenderer


      attr_accessor :paginator
      
      def initialize(paginator)
        @paginator = paginator
        super File.dirname(__FILE__) + "/help_list.erb"
      end
      
      def section_topics(section)
        Help.toc_topics(section)
      end      
    end
  end
end
