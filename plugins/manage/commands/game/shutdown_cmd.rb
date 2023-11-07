module AresMUSH
  module Manage
    class ShutdownCmd
      include CommandHandler
      
      attr_accessor :announce
      
      def parse_args
        self.announce = cmd.args
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end

      def handle
        message = self.announce ? t('manage.shutdown_with_message', :message => self.announce, :name => enactor_name) :
                                   t('manage.shutdown', :name => enactor_name)
        Global.notifier.notify_ooc(:shutdown, message) do |char|
          true
        end
        
        Global.client_monitor.clients.each do |c|
          c.disconnect
        end
        
        Manage.save_db
        Global.shutdown
      end
    end
  end
end
