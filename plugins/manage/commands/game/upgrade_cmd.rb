module AresMUSH
  module Manage
    class UpgradeCmd
      include CommandHandler
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.is_coder?
        return nil
      end
      
      def handle
        if (cmd.switch_is?("finish"))
          finish_upgrade
        else
          start_upgrade
        end
      end
      
      def start_upgrade
        Global.dispatcher.spawn("Upgrade action.", client) do
          output = `/home/ares/aresmush/bin/upgrade 2>&1`
          client.emit_success t('manage.upgrade_output', :output => output)
        end
      end
      
      def finish_upgrade
        ['load all', 'migrate', 'website/deploy'].each do |command|
          Global.dispatcher.queue_command(client, Command.new(command))
        end
      end
    end
  end
end
