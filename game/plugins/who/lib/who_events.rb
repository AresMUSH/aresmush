module AresMUSH
  module Who
    class WhoEvents
      include Plugin

      
      def on_char_connected(args)
        count = Global.client_monitor.logged_in_clients.count
        
        if (count > Game.online_record)
          Game.online_record = count
          Global.logger.info("Online Record Now: #{count}")
          Global.client_monitor.emit_all_ooc t('who.new_online_record', :count => count)
        end
      end      
    end
  end
end
