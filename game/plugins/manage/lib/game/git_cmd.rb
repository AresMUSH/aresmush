module AresMUSH
  module Manage
    class GitCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      
      attr_accessor :args
      
      def crack!
        self.args = cmd.args
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end

      def handle
        output = `git #{self.args} 2>&1`
        client.emit_success t('manage.git_output', :output => output)
      end
    end
  end
end
