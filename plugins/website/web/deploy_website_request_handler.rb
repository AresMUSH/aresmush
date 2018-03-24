module AresMUSH
  module Website
    class DeployWebsiteRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (!enactor.is_admin?)
          return { error: t('dispatcher.not_allowed') }
        end
        
        WebHelpers.deploy_portal
        
        { }
      end
    end
  end
end