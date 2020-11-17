module AresMUSH
  module Login
    class UpdateAccountInfoRequestHandler
      def handle(request)
        enactor = request.enactor
        name = request.args[:name]
        email = request.args[:email]
        timezone = request.args[:timezone]
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
        
        if (!enactor.is_approved?)
          name_validation_msg = Character.check_name(name)
          if (name_validation_msg)
            return { error: name_validation_msg }
          end
          
          taken_error = Login.name_taken?(name, enactor)
          if (taken_error)
            return { error: taken_error }
          end
        
          enactor.update(name: name)
        end
        
        if (!enactor.handle)
          timezone_error = OOCTime.set_timezone(enactor, timezone)
          if (timezone_error)
            return { error: timezone_error }
          end
        end
        
        {
        }
      end
    end
  end
end