module AresMUSH
  module Who
    class WhoChar < MustacheFormatter
      def initialize(client, container)
        @client = client        
        @config_reader = container.config_reader
      end

      def template
        @config_reader.config["who"]["char_template"]
      end

      def name
        @client.name.ljust(20)
      end
      
      def idle
        @client.idle.ljust(5)
      end
      
      def status
        "#{@client.char["status"]}".ljust(5)
      end
    end
  end
end