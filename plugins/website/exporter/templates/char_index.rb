module AresMUSH
  module Website
    class WikiExportCharIndexTemplate < ErbTemplateRenderer
            
      attr_accessor :chars
      
      def initialize(chars)
        @chars = chars
        super File.dirname(__FILE__) + "/char_index.erb"
      end
      
      def avatar(char)
        Website.avatar_info(char)
      end
      
      def icon(char)
        avatar(char)["icon"]
      end
      
      def icon_classes(char)
        avatar(char)["classes"]
      end
    end
  end
end