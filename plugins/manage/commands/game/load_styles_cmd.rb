module AresMUSH
  module Manage
    class LoadStylesCmd
      include CommandHandler
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end

      def handle
        error = Website.rebuild_css
        if (error)
          client.emit_failure error
          return
        end
        client.emit_success t('manage.styles_loaded')
      end
      
    end
  end
end
