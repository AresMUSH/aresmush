module AresMUSH
  module Who
    class WhoCharFormatter < MustacheFormatter
      def initialize(client, container)
        @client = client        
        @config_reader = container.config_reader
      end

      def template
        @config_reader.config["who"]["char_template"]
      end

      def name
        @client.name.ljust(name_width)
      end
      
      def name_width
        20
      end

      def idle
        @client.idle.ljust(idle_width)
      end
      
      def idle_width
        5
      end
      
      def status
        "#{@client.char["status"]}".ljust(status_width)
      end
      
      def status_width
        5
      end
    end
  end
end