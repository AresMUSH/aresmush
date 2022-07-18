module AresMUSH
  module Help
    class HelpListTemplate < ErbTemplateRenderer


      attr_accessor :paginator
      
      def initialize(paginator)
        @paginator = paginator
        super File.dirname(__FILE__) + "/help_list.erb"
      end
      
      def toc_topics(section)
        Help.toc_section_topic_data(section)
             .select { |name, data| data['tutorial'] }
             .sort_by { |name, data| [ data['order'] || 99, name ] }
      end
      
      def section_topics(section)
        Help.toc_section_topic_data(section)
        .select { |name, data| !data['tutorial'] }
        .sort_by { |name, data| [ data['order'] || 99, name ] }
        .map { |name, data| name.humanize.titleize }
        .join( ' | ' )
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
      
      def page_display
        center("%xh[ #{paginator.page_marker} ~ #{next_page_tip} ]%xn", 78, '-')
      end
      
      def next_page_prompt
        if (@paginator.current_page != @paginator.total_pages)
          t('help.pages_tip', :next_page => paginator.current_page + 1)
        else
          ""
        end
      end
    end
  end
end
