module AresMUSH
  module Login
    class BanPlayerRequestHandler
      def handle(request)
        enactor = request.enactor
        name = request.args[:name]
        reason = request.args[:reason]
        
        error = Website.check_login(request)
        return error if error
        
        if !enactor.is_admin?
          return { error: t('dispatcher.not_allowed') }
        end

        if (reason.blank?)
          return { error: t('webportal.missing_required_fields') }
        end
        
        char = Character.named(name)
        if (!char)
          return { error: t('webportal.not_found') }
        end

        error = Login.ban_player(enactor, char, reason)
        if (error) 
          return { error: error }  
        end
        
        {}
      end
    end
  end
end