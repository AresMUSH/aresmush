module AresMUSH
  module Manage
    class MigrateCmd
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
        
        error = Manage.run_migrations
        if (error)
          client.emit_failure error
        end
        # There was a global emit already so no need to re-emit if everything OK
      end
    end
  end
end
