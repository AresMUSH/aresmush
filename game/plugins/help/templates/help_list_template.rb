module AresMUSH
  module Help
    class HelpListTemplate < ErbTemplateRenderer


      attr_accessor :paginator
      
      def initialize(paginator)
        @paginator = paginator
        super File.dirname(__FILE__) + "/help_list.erb"
      end
      
      def section_topics(section)
        Help.toc_section_topic_data(section)
      end            
      
      def web_portal_url
        Game.web_portal_url
      end
      
      def topic_url(plugin, name)
        Help.topic_url(plugin, name)
      end
      
    end
  end
end
