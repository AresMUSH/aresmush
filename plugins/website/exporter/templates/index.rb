module AresMUSH
  module Website
    class WikiExportIndexTemplate < ErbTemplateRenderer
            
      def initialize()
        super File.dirname(__FILE__) + "/index.erb"
      end

      def mush_name
        Global.read_config("game", "name")
      end
      
      def welcome_text
        Website.welcome_text
      end
     
    end
  end
end