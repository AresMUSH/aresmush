module AresMUSH
  module Login
    class EditMotdRequestHandler
      def handle(request)      
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        if !Login.can_manage_login?(enactor)
          return { error: t('dispatcher.not_allowed') } 
        end
        
        
        {
          motd: Game.master.login_motd
        }
      end
    end
  end
end