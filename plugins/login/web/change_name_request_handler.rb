module AresMUSH
  module Login
    class ChangeNameRequestHandler
      def handle(request)
        enactor = request.enactor
        name = request.args[:name]
        pw = request.args[:confirm_password]

        error = Website.check_login(request)
        return error if error
        
        if (!enactor.compare_password(pw))
          return { error: t('login.invalid_password') }
        end
        
        name_validation_msg = Character.check_name(name, enactor)
        if (name_validation_msg)
          return { error: name_validation_msg }
        end
        
        enactor.update(name: name)
        
        {
        }
      end
    end
  end
end