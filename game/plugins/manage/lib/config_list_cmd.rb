module AresMUSH
  module Manage
    class ConfigListCmd
      include AresMUSH::Plugin

      # Validators
      must_be_logged_in
      
      def want_command?(client, cmd)
        cmd.root_is?("config") && cmd.switch.nil? && cmd.args.nil?
      end

      # TODO - validate permissions
      
      def handle
        output = "%l1"
        output << "%r%xh#{t('manage.config_sections')}%xn"
        Global.config.keys.each do |k|
          output << "%r#{k}"
        end
        output << "%R%l1"
        client.emit output
      end
    end
  end
end