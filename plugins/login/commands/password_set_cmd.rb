module AresMUSH
  module Login
    class PasswordSetCmd
      include CommandHandler
      
      attr_accessor :old_password
      attr_accessor :new_password
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.old_password = args.arg1
        self.new_password = args.arg2
      end

      def required_args
        [ self.old_password, self.new_password ]
      end
      
      def check_new_password
        return t('dispatcher.invalid_syntax', :cmd => 'passsword') if !self.new_password
        return Character.check_password(self.new_password)
      end
      
      def handle
        if (!enactor.compare_password(self.old_password))
          client.emit_failure(t('login.password_incorrect'))
          return 
        end
        enactor.change_password(self.new_password)
        client.emit_success t('login.password_changed')
      end
      
      def log_command
        # Don't log full command for password privacy
        Global.logger.debug("#{self.class.name} #{client}")
      end
    end
  end
end
