module AresMUSH
  module Manage
    class ConfigListCmd
      include AresMUSH::Plugin

      # Validators
      must_be_logged_in
      
      def want_command?(client, cmd)
        cmd.root_is?("config") && cmd.switch.nil? && cmd.args.nil?
      end

      # TODO - check permissions
      
      def handle
        client.emit BorderedDisplay.table(Global.config.keys, 25, t('manage.config_sections'))
      end
    end
  end
end