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

        message = Manage.start_upgrade
        Global.client_monitor.notify_web_clients(:manage_activity, Website.format_markdown_for_html(message), true) do |c|
           c == enactor
        end        
        
        migrator = DatabaseMigrator.new
        if (migrator.restart_required?)
          return { message: t('manage.restart_required') }
        end
        
        if (Manage.server_reboot_required?)
          return { message: t('manage.server_reboot_required') }
        end

       message = Manage.finish_upgrade(enactor, true)
       {
         message:  Website.format_markdown_for_html(message)
       }
      end
    end
  end
end