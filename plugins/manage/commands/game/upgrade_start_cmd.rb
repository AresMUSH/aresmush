module AresMUSH
  module Manage
    class UpgradeStartCmd
      include CommandHandler
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.is_coder?
        return nil
      end
      
      def handle
        Global.dispatcher.spawn("Upgrade action.", client) do
          output = `/home/ares/aresmush/bin/upgrade 2>&1`
          client.emit_success t('manage.upgrade_output', :output => output)
        end
      end
    end
  end
end
