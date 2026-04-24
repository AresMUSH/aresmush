module AresMUSH
  module Login
    class SaveMotdRequestHandler
      def handle(request)      
        enactor = request.enactor
        motd = request.args['motd']
        
        error = Website.check_login(request)
        return error if error
        
        if !Login.can_manage_login?(enactor)
          return { error: t('dispatcher.not_allowed') } 
        end

        Game.master.update(login_motd: motd)
        
        {
        }
      end
    end
  end
end