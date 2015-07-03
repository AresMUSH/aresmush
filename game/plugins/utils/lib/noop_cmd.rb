module AresMUSH
  module Utils
    class NoOpCmd
      include Plugin
      include PluginWithoutSwitches

      attr_accessor :message

      def want_command?(client, cmd)
        cmd.root_is?("@")
      end

      def handle
        # A command that does absolutely nothing!
      end

      def log_command
        # Don't log useless command
      end
    end
  end
end