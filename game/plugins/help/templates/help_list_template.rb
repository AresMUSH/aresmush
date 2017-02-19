module AresMUSH
  module Help
    class HelpListTemplate < ErbTemplateRenderer


      attr_accessor :category, :paginator
      
      def initialize(paginator, category)
        @paginator = paginator
        @category = category
        super File.dirname(__FILE__) + "/help_list.erb"
      end
            
      def title
        t('help.toc', :category => Help.category_config[self.category]["title"])
      end    
      
      def section_topics(section)
        Help.toc_topics(self.category, section)
      end
      
      def other_cats
        Help.category_config
      end
    end
  end
end
