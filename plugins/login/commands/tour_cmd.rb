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
        guests = Login.guests
        
        if (guests.count == 0)
          message = Global.read_config('login', 'guest_disabled_message')
          if (message.blank?)
            message = t('login.no_guests')
          end
          client.emit_failure message
          return
        end
        
        guest = guests.sort_by{ |g| g.name }.select { |g| !Login.is_online?(g) }.first

        if (!guest)
          client.emit_ooc t('login.all_guests_taken')
          return
        end
        
        if (!Login.can_login?(guest))
          client.emit_failure t('login.login_restricted', :reason => Login.restricted_login_message)
          return
        end
        
        client.char_id = guest.id
        terms_of_service = Login.terms_of_service
        if (terms_of_service)
          template = BorderedDisplayTemplate.new "#{terms_of_service}"
          client.emit template.render
        end
        
        Global.dispatcher.queue_timer(2, "Tell guest their name", client) do
          client.emit_success t('login.guest_name', :name => guest.name)
        end
        
        Global.dispatcher.queue_event CharConnectedEvent.new(client, guest.id)
      end
    end
  end
end
