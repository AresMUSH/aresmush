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
        
        error = Manage.finish_upgrade
        if (error)
          client.emit_failure error
        else
          client.emit_success t('global.done')
        end
      end
    end
  end
end
