module AresMUSH
  module Help
    class HelpDetailTemplate < ErbTemplateRenderer


      attr_accessor :topic_found, :topic_key
      
      def initialize(topic_key, topic_found)
        @topic_key = topic_key
        @topic_found = topic_found
        
        super File.dirname(__FILE__) + "/help_detail.erb"
      end
      
      def contents
        formatter = MarkdownFormatter.new
        md_contents = Help.topic_contents(@topic_found)
        formatter.to_mush(md_contents)
      end
      
      def help_url
        Help.topic_url(@topic_found, @topic_key.rest(' '))
      end
    end
  end
end
