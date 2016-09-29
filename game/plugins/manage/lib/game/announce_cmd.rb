module AresMUSH
  module Manage
    class AnnounceCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :message
      
      def initialize(client, cmd, enactor)
        self.required_args = ['message']
        self.help_topic = 'announce'
        super
      end
      
      def crack!
        self.message = cmd.args
      end

      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end
      
      def handle
        msg = PoseFormatter.format(enactor_name, self.message)
        Global.client_monitor.emit_all t('manage.announce', :message => msg)
      end
    end
  end
end