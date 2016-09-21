module AresMUSH
  module Manage
    class ShutdownCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
      include CommandWithoutSwitches
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(client.char)
        return nil
      end

      def handle
        Global.client_monitor.clients.each do |c|
          c.emit_ooc t('manage.shutdown', :name => client.name)
          c.disconnect
        end
        
        # Don't use dispatcher here because we want a hard kill
        EventMachine.add_timer(1) do
          EventMachine.stop_event_loop
        end
      end
    end
  end
end
