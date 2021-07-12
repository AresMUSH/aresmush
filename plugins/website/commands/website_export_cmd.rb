module AresMUSH
  module Website
    class WebsiteExportCmd
      include CommandHandler
           
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end
                  
      def handle
        client.emit_ooc t('webportal.exporting_wiki')
        Website.export_wiki(client)
      end
    end
  end
end
