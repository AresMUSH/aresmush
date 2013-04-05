module AresMUSH
  module Login
    class LoginEvents
      include AresMUSH::Plugin

      def after_initialize
        @client_monitor = container.client_monitor
      end
      
      def on_char_connected(args)
        client = args[:client]
        logger.info("Character Connected: #{client}")
        client.emit_success(t('login.welcome'))
        @client_monitor.emit_all t('login.announce_char_connected', :name => client.name)
      end
      
      def on_char_created(args)
        client = args[:client]
        logger.info("Character Created: #{client}")
        @client_monitor.emit_all t('login.announce_char_created', :name => client.name)
      end

      def on_char_disconnected(args)
        client = args[:client]
        logger.info("Character Disconnected: #{client}")
        @client_monitor.emit_all t('login.announce_char_disconnected', :name => client.name)
      end
    end
  end
end
