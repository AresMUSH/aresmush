module AresMUSH
  module Manage
    class ServerInfoCmd
      include CommandHandler
           
      def check_is_allowed
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end
      
      def handle
        template = ServerTemplate.new
        client.emit template.render
      end

    end
  end
end
