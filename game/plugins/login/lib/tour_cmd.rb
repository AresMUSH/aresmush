module AresMUSH
  module Login
    class TourCmd
      include Plugin
      include PluginWithoutSwitches
      include PluginWithoutArgs
      
      def want_command?(client, cmd)
        cmd.root_is?("tour")
      end
      
      def check_not_already_logged_in
        return t("login.already_logged_in") if client.logged_in?
        return nil
      end

      def handle
        guests = Character.where(:roles.in => [ "guest" ]).all
        
        guest = guests.sort_by{ |g| g.name }.select { |g| Global.client_monitor.find_client(g).nil? }
        if (guest.empty?)
          client.emit_ooc t('login.all_guests_taken')
          return
        end
        
        channels = Global.config['login']['guest_channels']
        channels.each do |c|
          Channels.join_channel(c, client, guest.first, nil)
        end
        
        client.char = guest.first
        terms_of_service = Login.terms_of_service
        if (!terms_of_service.nil?)
          client.emit "%l1%r#{terms_of_service}%r%l1"
        end
        Global.dispatcher.queue_event CharConnectedEvent.new(client)
      end
    end
  end
end
