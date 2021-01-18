module AresMUSH
  module Website
    class DeployWebsiteRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        request.log_request
        
        if (!Manage.can_manage_game?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
                
        Website.redeploy_portal(enactor, true)
        
        {
          message:  Website.format_markdown_for_html(t('webportal.redeploying_website'))
        }
        
      end
    end
  end
end