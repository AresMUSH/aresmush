module AresMUSH
  module Manage
    class UpgradeFinishCmd
      include CommandHandler
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.is_coder?
        return nil
      end
      
      def handle
        ['load all', 'migrate', 'load config', 'website/deploy'].each do |command|
          Global.dispatcher.queue_command(client, Command.new(command))
        end
      end
    end
  end
end
