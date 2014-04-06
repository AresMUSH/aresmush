module AresMUSH
  module Manage
    class ConfigListCmd
      include Plugin
      include PluginRequiresLogin
      
      def want_command?(client, cmd)
        cmd.root_is?("config") && cmd.switch.nil? && cmd.args.nil?
      end

      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage?(client.char)
        return nil
      end
      
      def handle
        client.emit BorderedDisplay.table(Global.config.keys, 25, t('manage.config_sections'))
      end
    end
  end
end