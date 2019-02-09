module AresMUSH
  module Help
    class HelpListTemplate < ErbTemplateRenderer


      attr_accessor :paginator
      
      def initialize(paginator)
        @paginator = paginator
        super File.dirname(__FILE__) + "/help_list.erb"
      end
      
      def section_topics(section)
        Help.toc_section_topic_data(section).sort_by { |name, data| [ data['order'] || 99, name ] }
      end            
      
      def web_portal_url
        Game.web_portal_url
      end
      
      def topic_url(name)
        Help.topic_url(name)
      end
      
      def help_url
        "#{web_portal_url}/help"
      end
    end
  end
end
