module AresMUSH
  module Manage
    class LoadHelpCmd
      include AresMUSH::Plugin

      # Validators
      must_be_logged_in
      
      def want_command?(client, cmd)
        cmd.root_is?("load") && cmd.args == "help"
      end

      # TODO - validate permissions
      
      def handle
        begin
          Global.help_reader.read
          client.emit_success t('manage.help_loaded')
        rescue Exception => e
          client.emit_failure t('manage.error_loading_help', :error => e.to_s)
        end
      end
      
    end
  end
end
