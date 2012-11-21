module AresMUSH
  module Login
    class LoginEvents
      include AresMUSH::Plugin

      def after_initialize
        @client_monitor = container.client_monitor
      end
      
      def on_player_connected(args)
        client = args[:client]
        @client_monitor.tell_all t('login.player_has_connected', :name => client.id)
        client.tell("HI #{container.config_reader.config['login']['test']}")
      end

      def on_player_disconnected(args)
        client = args[:client]
        @client_monitor.tell_all t('login.player_has_disconnected', :name => client.id)
      end
    end
  end
end
