module AresMUSH
  module Login
    class PasswordResetCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = trim_arg(cmd.args)
      end

      def required_args
        [ self.name ]
      end
      
      def check_can_reset
        return t('dispatcher.not_allowed')  if !Login.can_manage_login?(enactor)
        return nil
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |char|
          
          if (char.is_master_admin?)
            client.emit_failure t('login.cant_reset_master_admin_password')
            return
          end
          
          new_password = Login.set_random_password(char)
          client.emit_success t('login.password_reset', :name => char.name, :password => new_password)
        end
      end
      
      def log_command
        # Don't log full command for password privacy
        name = !cmd.args ? "" : cmd.args.first("=")
        Global.logger.debug("#{self.class.name} #{client} #{name}")
      end
    end
  end
end
