module AresMUSH
  module Login
    class RegisterRequestHandler
      def handle(request)
        recaptcha = AresMUSH::Website::RecaptchaHelper.new
        turnstile = AresMUSH::Website::TurnstileHelper.new
        
        if (request.enactor)
          return { message: 'login.already_logged_in' }
        end
        
        if (!Login.allow_web_registration?)
          return { message: t('login.web_registration_disabled') }
        elsif (Login.is_banned?(nil, request.ip_addr, request.hostname))
          return { error: Login.site_blocked_message }
        end
                      
        name = request.args['name']
        pw = request.args['password']
        confirm_pw = request.args['confirm_password']
        recaptcha_response = request.args['recaptcha']
        turnstile_response = request.args['turnstile']
        
        Global.logger.info "#{name} registered from web from #{request.ip_addr}."
      
        if (turnstile.is_enabled?)
          if (!turnstile.verify(turnstile_response))
            return { error: t('login.captcha_failed') }
          end
        elsif (recaptcha.is_enabled?)
          if (!recaptcha.verify(recaptcha_response))
            return { error: t('login.captcha_failed') }
          end
        end
      
        name_error = Character.check_name(name)
        password_error = Character.check_password(pw)
        taken_error = Login.name_taken?(name)
      
        if (pw != confirm_pw)
          return { error: t('login.passwords_dont_match') }
        elsif name_error
          return { error: name_error }
        elsif password_error
          return { error: password_error }
        elsif taken_error
          return { error: taken_error }
        end 
        char = Character.new
        char.name = name
        char.change_password(pw)
        char.room = Game.master.welcome_room
        char.last_on = Time.now
        char.set_login_token
        Login.update_site_info(request.ip_addr, request.hostname, char)
        
        if (Login.terms_of_service)
          char.update(terms_of_service_acknowledged: Time.now)
        end
        char.save
              
        Global.dispatcher.queue_event CharCreatedEvent.new(nil, char.id)
      
        Login.web_session_info(char)
      end
    end
  end
end