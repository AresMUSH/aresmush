module AresMUSH
  module Login
    class BanRemoveRequestHandler
      def handle(request)
        enactor = request.enactor
        site = request.args[:site]
        
        error = Website.check_login(request)
        return error if error
        
        if !enactor.is_admin?
          return { error: t('dispatcher.not_allowed') }
        end

        error = Login.remove_site_ban(enactor, site)
        if (error) 
          return { error: error }  
        end
        
        {}
      end
    end
  end
end