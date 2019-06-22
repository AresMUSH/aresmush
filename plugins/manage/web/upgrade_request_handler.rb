module AresMUSH
  module Manage
    class UpgradeRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error

        if !Manage.can_manage_game?(enactor)
          return { error: t('dispatcher.not_allowed') }
        end

        Manage.start_upgrade
        
        migrator = DatabaseMigrator.new
        if (migrator.restart_required?)
          return { restart_required: true }
        end
        
        error = Manage.finish_upgrade
        if (error)
          return { error: error }
        end
        
       {
         restart_required: false
       }
      end
    end
  end
end