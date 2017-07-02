module AresMUSH
  module Login
    class TourCmd
      include CommandHandler

      def allow_without_login
        true
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
        
        guest = guest.first
        client.char_id = guest.id
        terms_of_service = Login.terms_of_service
        if (terms_of_service)
          template = BorderedDisplayTemplate.new "#{terms_of_service}"
          client.emit template.render
        end
        
        Global.dispatcher.queue_timer(2, "Tell guest their name", client) do
          client.emit_success t('login.guest_name', :name => guest.name)
        end
        
        Global.dispatcher.queue_event CharConnectedEvent.new(client, guest)
      end
    end
  end
end
