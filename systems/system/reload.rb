module AresMUSH
  module Commands
    class Reload
      def initialize(config_reader, client_monitor)
        @config_reader = config_reader
        @client_monitor = client_monitor
        @client_monitor.register(self)
      end

      def handles
        ["reload (?<system_name>.+)"]
      end

      def handle(client, cmd)
        system_name = cmd[:system_name]
        begin
          SystemManager.reload(system_name)
          client.emit_success "Reloading #{system_name} system."
        rescue Exception => e
          client.emit_failure "Can't find #{system_name} system. #{e.to_s}"
        end
      end
    end
  end
end
