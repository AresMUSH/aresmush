module AresMUSH
  module Login
    class SetEmailRequestHandler
      def handle(request)
        enactor = request.enactor
        email = request.args[:email]
        pw = request.args[:confirm_password]

        error = Website.check_login(request)
        return error if error
        
        if (!enactor.compare_password(pw))
          return { error: t('login.invalid_password') }
        end
        
        if !Login.is_email_valid?(email)
          return { error: t('login.invalid_email_format') }
        end
                
        enactor.update(login_email: email)
        
        {
        }
      end
    end
  end
end