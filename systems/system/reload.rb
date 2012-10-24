module AresMUSH
  module Commands
    class Reload
      def initialize(container)
        @system_manager = container.system_manager
      end

      def commands
        ["reload (?<system_name>.+)"]
      end

      def handle(client, cmd)
        system_name = cmd[:system_name]
        begin
          @system_manager.reload(system_name)
          client.emit_success "%% Reloading #{system_name} system."
        rescue Exception => e
          client.emit_failure "%% Can't find #{system_name} system. #{e.to_s}"
        end
      end
    end
  end
end
