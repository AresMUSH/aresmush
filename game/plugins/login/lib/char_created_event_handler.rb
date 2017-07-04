module AresMUSH
  module Login
    class CharCreatedEventHandler
      def on_event(event)
        client = event.client
        char = event.char
        Global.logger.info("Character Created: #{char.name}")
        
        if (client)
          Global.client_monitor.emit_all_ooc t('login.announce_char_created', :name => char.name)
        end
      end
    end
  end
end
