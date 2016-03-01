module AresMUSH
  module Manage
    class ReloadCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
      include CommandWithoutSwitches
      
      def want_command?(client, cmd)
        cmd.root_is?("reload")
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(client.char)
        return nil
      end

      def handle
        Global.client_monitor.reload_clients
        client.emit_success t('manage.objects_reloaded')
      end
    end
  end
end
