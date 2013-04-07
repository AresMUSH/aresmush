module AresMUSH
  module Who
    class WhoHeader < TemplateRenderer
      def initialize(clients, container)
        @config_reader = container.config_reader
      end

      def template
        @config_reader.config["who"]["header"]
      end

      def mush_name
        @config_reader.config["theme"]["mush_name"]
      end 
           
    end
  end
end