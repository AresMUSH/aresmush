module AresMUSH
  module Website
    class WikiExportCharIndexTemplate < ErbTemplateRenderer
            
      attr_accessor :chars
      
      def initialize(chars)
        @chars = chars
        super File.dirname(__FILE__) + "/char_index.erb"
      end
      
      def icon(char)
        Website.icon_for_char(char)
      end
    end
  end
end