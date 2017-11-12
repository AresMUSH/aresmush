module AresMUSH
  module Utils
    class SetCatcherCmd
      include CommandHandler

      def handle
        client.emit_failure t('utils.no_set_cmd')
      end

      def log_command
        # Don't log useless command
      end
    end
  end
end