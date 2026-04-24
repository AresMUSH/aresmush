module AresMUSH
  module Login
    class ResetPasswordRequestHandler
      def handle(request)
        enactor = request.enactor
        id = request.args['id']

        error = Website.check_login(request)
        return error if error
        
        char = Character[id]
        if (!char)
          return { error: t('webportal.not_found') }
        end
        
        Global.logger.info "#{enactor.name} resetting password for #{char.name}."
        
        if !Login.can_manage_login?(enactor)
          return { error: t('dispatcher.not_allowed') }
        end

        new_pw = Login.set_random_password(char)
        
        {
          new_password: new_pw
        }
      end
    end
  end
end