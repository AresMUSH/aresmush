module AresMUSH
  module Website
    class WikiExportDefaultTemplate < ErbTemplateRenderer
            
      attr_accessor :text, :title 
      def initialize(text, title)
        @text = text
        @title = title
        
        super File.dirname(__FILE__) + "/default.erb"
      end

      def mush_name
        Global.read_config("game", "name")
      end
      
      def welcome
        Website.welcome_text
      end
     
    end
  end
end