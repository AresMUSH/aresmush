module AresMUSH
  module Manage
    class MigrateCmd
      include CommandHandler
     
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.is_coder?
        return nil
      end

      def handle
        Manage.announce t('manage.migrations_in_progress')
        migrator = DatabaseMigrator.new
        migrator.migrate(client)
        Manage.announce t('manage.migrations_complete')
      end
    end
  end
end