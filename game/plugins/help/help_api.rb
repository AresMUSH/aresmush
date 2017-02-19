module AresMUSH
  module Help
    module Api
      def self.get_help(topic_key, category = "main")
        Help.topic_contents(topic_key, category)
      end
      
      def self.help_topics
        Help.help_topics
      end
      
      def self.reload_help
        Help.reload_help
      end
    end    
  end
end
