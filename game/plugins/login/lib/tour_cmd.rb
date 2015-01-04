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
        guest = Login.guests.sort_by{ |g| g.name }.select { |g| !g.is_online? }
        if (guest.empty?)
          client.emit_ooc t('login.all_guests_taken')
          return
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
