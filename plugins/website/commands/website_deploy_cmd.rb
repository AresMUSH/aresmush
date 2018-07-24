module AresMUSH
  module Website
    class WebsiteDeployCmd
      include CommandHandler
            
      def handle
        client.emit_ooc t('webportal.redeploying_website')
        Website.deploy_portal(client)
        
      end
    end
  end
end
