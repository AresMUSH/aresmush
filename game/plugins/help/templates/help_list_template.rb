module AresMUSH
  module Help
    class HelpListTemplate < ErbTemplateRenderer


      attr_accessor :paginator, :toc_list
      
      def initialize(paginator, toc_list)
        @paginator = paginator
        @toc_list = toc_list
        super File.dirname(__FILE__) + "/help_list.erb"
      end
      
      def section_topics(section)
        toc_list[section]
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
