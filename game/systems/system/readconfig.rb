module AresMUSH
  module EventHandlers
    class ReadConfig
      def initialize(container)
        @client_monitor = container.client_monitor
        @config_reader = container.config_reader
      end

      def commands
        ["readconfig"]
      end

      def on_player_command(client, cmd)
        @config_reader.read
        client.emit_success "You reload the config files."
      end
    end
  end
end
