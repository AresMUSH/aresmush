module AresMUSH
  module Login
    class TourRequestHandler
      def handle(request)
        enactor = request.enactor

        error = Website.check_login(request, true)
        return error if error
        
        if (request.enactor)
          return { message: 'login.already_logged_in' }
        end
        
        reason = Global.read_config('login', 'tour_not_allowed_message')
        if (!Login.allow_web_tour?)
          return { error: t('login.tour_restricted', :reason => reason)  }
        elsif (Login.is_banned?(nil, request.ip_addr, request.hostname))
          return { error: Login.site_blocked_message }
        end
        
        name = Login.create_temp_char_name
        password = Login.generate_random_password
              
        char = Login.register_and_login_char(name, password, Login.terms_of_service)
        Login.send_tour_welcome(char, password)
        
        Login.update_site_info(request.ip_addr, request.hostname, char)
        Global.dispatcher.queue_event CharCreatedEvent.new(nil, char.id)
                
        {
          session: Login.web_session_info(char),
          name: name,
          password: password
        }
          
      end
    end
  end
end