module AresMUSH
  module Login
    class LoginEvents
      include Plugin
      
      def on_char_connected(args)
        client = args[:client]
        Global.logger.info("Character Connected: #{client}")
        Global.client_monitor.emit_all_ooc t('login.announce_char_connected', :name => client.name)
        
        terms_of_service = Login.terms_of_service
        if (client.char.has_role?("guest") && !terms_of_service.nil?)
          client.emit "%l1%r#{terms_of_service}%r%l1"
        end
      end
      
      def on_char_created(args)
        client = args[:client]
        Global.logger.info("Character Created: #{client}")
        Global.client_monitor.emit_all_ooc t('login.announce_char_created', :name => client.name)
      end

      def on_char_disconnected(args)
        client = args[:client]
        Global.logger.info("Character Disconnected: #{client}")
        Global.client_monitor.emit_all_ooc t('login.announce_char_disconnected', :name => client.name)
      end
    end
  end
end
