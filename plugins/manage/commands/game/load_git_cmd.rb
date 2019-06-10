module AresMUSH
  module Manage
    class LoadGitCmd
      include CommandHandler
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end
      
      def handle
        Global.dispatcher.queue_command(client, Command.new("git pull"))
        Global.dispatcher.queue_command(client, Command.new("load all"))
      end
      
    end
  end
end
