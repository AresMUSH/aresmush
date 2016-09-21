module AresMUSH
  module Login
    class PasswordSetCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :old_password
      attr_accessor :new_password

      def initialize
        self.required_args = ['old_password', 'new_password']
        self.help_topic = 'password'
        super
      end

      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.old_password = cmd.args.arg1
        self.new_password = cmd.args.arg2
      end
      
      def check_new_password
        return t('dispatcher.invalid_syntax', :command => 'passsword') if self.new_password.nil?
        return Character.check_password(self.new_password)
      end
      
      def handle
        char = client.char
        if (!char.compare_password(self.old_password))
          client.emit_failure(t('login.password_incorrect'))
          return 
        end
        char.change_password(self.new_password)
        char.save!
        client.emit_success t('login.password_changed')
      end
      
      def log_command
        # Don't log full command for password privacy
        Global.logger.debug("#{self.class.name} #{client}")
      end
    end
  end
end
