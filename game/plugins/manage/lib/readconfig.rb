module AresMUSH
  module System
    class Manage
      include AresMUSH::Plugin

      def after_initialize
        @client_monitor = container.client_monitor
        @config_reader = container.config_reader
      end

      def want_command?(cmd)
        cmd.root_is?("readconfig")
      end

      # TODO - Just a prototype
      def on_command(client, cmd)
        @config_reader.read
        client.emit_success "You reload the config files."
      end
    end
  end
end
