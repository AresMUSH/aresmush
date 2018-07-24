module AresMUSH
  module Website
    class DeployWebsiteRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        if (!Manage.can_manage_game?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        Website.deploy_portal
        
        { }
      end
    end
  end
end