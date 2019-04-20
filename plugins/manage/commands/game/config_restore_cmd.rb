module AresMUSH
  module Manage
    class ConfigRestoreCmd
      include CommandHandler

      attr_accessor :name
      
      def parse_args
        self.name = downcase_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end
            
      def handle
        if (!self.name.end_with?(".yml"))
          self.name = "#{self.name}.yml"
        end

        error = Manage.restore_config(self.name)
        if (error)
          client.emit_failure t('manage.error_restoring_config', :error => error)
        else
          client.emit_success t('manage.config_restored', :name => self.name)
        end
      end
    end
  end
end