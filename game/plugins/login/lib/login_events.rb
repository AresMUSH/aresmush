module AresMUSH
  module Login
    class LoginEvents
      include AresMUSH::Plugin

      def after_initialize
        @client_monitor = container.client_monitor
      end
      
      def on_player_connected(args)
        client = args[:client]
        logger.info("Player Connected: #{client}")
        client.emit_success(t('login.welcome'))
        @client_monitor.emit_all t('login.announce_player_connected', :name => client.name)
      end
      
      def on_player_created(args)
        client = args[:client]
        logger.info("Player Created: #{client}")
        @client_monitor.emit_all t('login.announce_player_created', :name => client.name)
      end

      def on_player_disconnected(args)
        client = args[:client]
        logger.info("Player Disconnected: #{client}")
        @client_monitor.emit_all t('login.announce_player_disconnected', :name => client.name)
      end
    end
  end
end
