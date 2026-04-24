module AresMUSH
  module Login
    class BootPlayerRequestHandler
      def handle(request)
        enactor = request.enactor
        name = request.args['name']
        reason = request.args['reason']
        
        error = Website.check_login(request)
        return error if error
        
        if !Login.can_boot?(enactor)
          return { error: t('dispatcher.not_allowed') }
        end

        if (reason.blank?)
          return { error: t('webportal.missing_required_fields', :fields => "reason") }
        end
        
        char = Character.named(name)
        if (!char)
          return { error: t('webportal.not_found') }
        end
        
        error = Login.boot_char(enactor, char, reason)
        if (error) 
          return { error: error }  
        end
        
        {}
      end
    end
  end
end