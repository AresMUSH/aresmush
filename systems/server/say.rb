module AresMUSH
  module Commands
    class Say
      def initialize(config_reader, client_monitor)
        @config_reader = config_reader
        @client_monitor = client_monitor
        @client_monitor.register(self)
      end

      def self.name
        "Say"
      end
      
      def handle(client, cmd)
        if cmd =~ /^say (?<msg>.+)/i
          msg = $~[:msg]
          puts "Say handling #{msg}"        
          @client_monitor.tell_all "Client #{client.id} says \"#{msg}\""
        end      
      end
    end
  end
end
