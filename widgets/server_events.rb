module AresMUSH
  module ServerEvents
    class ServerEvents
      def initialize(config_reader, client_monitor)
        @config_reader = config_reader
        @client_monitor = client_monitor
        @client_monitor.register(self)
      end

      def handle(client, cmd)
        if cmd =~ /quit/i
          client.disconnect
        elsif cmd =~ /readconfig/
          @config_reader.read
          client.emit "%% You reload the config files."
        else
          @client_monitor.tell_all "Client #{client.id} says #{cmd}"
        end      
      end
    end
  end
end
