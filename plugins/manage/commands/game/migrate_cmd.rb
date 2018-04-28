module AresMUSH
  module Manage
    class MigrateCmd
      include CommandHandler
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.is_coder?
        return nil
      end
      
      def handle
        Manage.announce t('manage.database_upgrade_in_progress')
        
        begin
          migrator = AresMUSH::DatabaseMigrator.new
          migrator.migrate(:online)
        rescue Exception => e
          Global.logger.debug "Error loading plugin: #{e}  backtrace=#{e.backtrace[0,10]}"
          client.emit_failure t('manage.error_running_migrations', :error => e)
        end
        
        Manage.announce t('manage.database_upgrade_complete')
      end
    end
  end
end
