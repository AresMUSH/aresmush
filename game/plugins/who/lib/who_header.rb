module AresMUSH
  module Who
    class WhoHeader < TemplateRenderer
      def initialize(clients)
      end

      def template
        Global.config["who"]["header"]
      end

      def mush_name
        Global.config["theme"]["mush_name"]
      end 
           
    end
  end
end