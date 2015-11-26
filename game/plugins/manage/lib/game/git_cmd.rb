module AresMUSH
  module Manage
    class GitCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches
      
      attr_accessor :args
      
      def want_command?(client, cmd)
        cmd.root_is?("git")
      end
      
      def crack!
        self.args = cmd.args
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(client.char)
        return nil
      end

      def handle
        output = `git #{self.args} 2>&1`
        client.emit_success t('manage.git_output', :output => output)
      end
    end
  end
end
