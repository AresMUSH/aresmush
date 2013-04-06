module AresMUSH
  module Who
    
    class WhoHeaderFormatter < MustacheFormatter
      def initialize(clients, container)
        @config_reader = container.config_reader
      end

      def template
        @config_reader.config["who"]["header_template"]
      end

      def mush_name
        @config_reader.config["theme"]["mush_name"]
      end      
    end
  end
end