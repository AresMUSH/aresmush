module AresMUSH
  module Who
    class Who
      include AresMUSH::Addon

      def after_initialize
        @client_monitor = container.client_monitor
      end

      def commands
        {
         "who" => "",
         "where" => "" 
        }
      end
      
      def on_player_command(client, cmd)
        client.emit_ooc t('players_connected', :count => @client_monitor.clients.count)
      end
    end
  end
end
