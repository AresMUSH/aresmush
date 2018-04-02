module AresMUSH
  module Manage
    class GitCmd
      include CommandHandler
      
      attr_accessor :args
      
      def parse_args
        self.args = cmd.args
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end

      def handle
        Global.dispatcher.spawn("Doing git query", client) do
          output = `git #{self.args} 2>&1`
          client.emit_success t('manage.git_output', :output => output)
        end
      end
    end
  end
end
