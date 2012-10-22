module AresMUSH
  module ServerEvents
    class Say
      def initialize(config_reader, client_monitor)
        @config_reader = config_reader
        @client_monitor = client_monitor
        @client_monitor.register(self)
      end

      def handle(client, cmd)
        puts "Say handling"        
        if cmd =~ /say/i
          @client_monitor.tell_all "Client #{client.id} says #{cmd}"
        end      
      end
    end
  end
end
