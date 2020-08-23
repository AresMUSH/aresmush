module AresMUSH
  module Login
    class ChangePasswordRequestHandler
      def handle(request)
        enactor = request.enactor
        pw = request.args[:current_password]
        new_pw = request.args[:new_password]
        confirm_pw = request.args[:confirm_password]

        error = Website.check_login(request)
        return error if error
        
        if (!enactor.compare_password(pw))
          return { error: t('login.invalid_password') }
        end
        
        password_error = Character.check_password(new_pw)
      
        if (new_pw != confirm_pw)
          return { error: t('login.passwords_dont_match') }
        elsif password_error
          return { error: password_error }
        end 

        enactor.change_password(new_pw)
        
        {
        }
      end
    end
  end
end