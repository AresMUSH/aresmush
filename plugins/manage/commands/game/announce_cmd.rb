module AresMUSH
  module Manage
    class AnnounceCmd
      include CommandHandler
      
      attr_accessor :message

      def parse_args
        self.message = cmd.args
      end
      
      def required_args
        [ self.message ]
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_announce?(enactor)
        return nil
      end
      
      def handle
        msg = PoseFormatter.format(enactor_name, self.message)
        Manage.announce(msg)
      end
    end
  end
end