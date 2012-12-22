module AresMUSH
  module Login
    class LoginEvents
      include AresMUSH::Plugin

      def after_initialize
        @client_monitor = container.client_monitor
      end
      
      def on_player_connected(args)
        client = args[:client]
        @client_monitor.emit_all t('login.player_has_connected', :name => client.name)
      end

      def on_player_disconnected(args)
        client = args[:client]
        @client_monitor.emit_all t('login.player_has_disconnected', :name => client.name)
      end
    end
  end
end
