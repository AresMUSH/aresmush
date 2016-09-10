module AresMUSH
  module Help
    module Interface
      def self.get_help(topic_key, category = "main")
        Help.topic_contents(topic_key, category)
      end
      
      def self.load_help
        Help.load_help
      end
    end    
  end
end
