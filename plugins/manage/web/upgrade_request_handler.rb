module AresMUSH
  module Manage
    class UpgradeRequestHandler
      def handle(request)
        enactor = request.enactor
        stage = request.args['stage'] || "all"
        
        error = Website.check_login(request)
        return error if error

        request.log_request

        if !Manage.can_manage_game?(enactor)
          return { error: t('dispatcher.not_allowed') }
        end

        if (stage == "start")
          message = Manage.start_upgrade
        elsif (stage == "finish")
          message = self.finish(enactor)
        else
          message = Manage.start_upgrade
          Global.client_monitor.notify_web_clients(:manage_activity, Website.format_markdown_for_html(message), true) do |c|
            c == enactor
          end
          message = self.finish
        end
        
        {
          message:  Website.format_markdown_for_html(message)
        }
      end      
      
      def finish(enactor)
        migrator = DatabaseMigrator.new
        if (migrator.restart_required?)
          return t('manage.restart_required')
        end
      
        if (Manage.server_reboot_required?)
          return t('manage.server_reboot_required')
        end

        Manage.finish_upgrade(enactor, true)
      end
    end
  end
end