module AresMUSH
  module Login
    class PasswordResetCmd
      include CommandHandler
      
      attr_accessor :name
      attr_accessor :new_password
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = trim_arg(args.arg1)
        self.new_password = args.arg2
      end

      def required_args
        {
          args: [ self.name, self.new_password ],
          help: 'password'
        }
      end
      
      def check_new_password
        return t('dispatcher.invalid_syntax', :command => 'passsword') if !self.new_password
        return Character.check_password(self.new_password)
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
          
          char.change_password(self.new_password)
          char.update(login_failures: 0)
          client.emit_success t('login.password_reset', :name => char.name)
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
