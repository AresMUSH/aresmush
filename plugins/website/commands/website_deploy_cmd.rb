module AresMUSH
  module Website
    class WebsiteDeployCmd
      include CommandHandler
           
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end
                  
      def handle
        client.emit_ooc t('webportal.redeploying_website')
        Website.redeploy_portal(enactor, false)
      end
    end
  end
end
