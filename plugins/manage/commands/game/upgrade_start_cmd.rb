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
          output = Manage.start_upgrade
          client.emit_success t('manage.upgrade_output', :output => output)
          if (output =~ /CONFLICT/)
            client.emit_failure t('manage.upgrade_conflict_warning')
          else
            client.emit_success t('manage.upgrade_continue')
          end
        end
      end
    end
  end
end
