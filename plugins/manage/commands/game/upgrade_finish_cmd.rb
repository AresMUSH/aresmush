module AresMUSH
  module Manage
    class UpgradeFinishCmd
      include CommandHandler
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.is_coder?
        return nil
      end
      
      def handle
        migrator = DatabaseMigrator.new
        if (migrator.restart_required?)
          client.emit_ooc t('manage.restart_required')
          return
        end
        
        if (Manage.server_reboot_required?)
          client.emit_ooc t('manage.server_reboot_required')
          return
        end
        
        message = Manage.finish_upgrade(enactor, false)
        client.emit_ooc message
      end
    end
  end
end
