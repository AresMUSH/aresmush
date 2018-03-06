module AresMUSH
  module Website
    class WebsiteDeployCmd
      include CommandHandler
            
      def handle
        client.emit_ooc t('webportal.redeploying_website')
        WebHelpers.deploy_portal
        
      end
    end
  end
end
