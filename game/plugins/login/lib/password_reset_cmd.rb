module AresMUSH
  module Login
    class PasswordResetCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name
      attr_accessor :new_password

      def initialize
        self.required_args = ['name', 'new_password']
        self.help_topic = 'password'
        super
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.name = trim_input(cmd.args.arg1)
        self.new_password = cmd.args.arg2
      end
      
      def check_new_password
        return t('dispatcher.invalid_syntax', :command => 'passsword') if self.new_password.nil?
        return Character.check_password(self.new_password)
      end
      
      def check_can_reset
        return t('dispatcher.not_allowed')  if !Login.can_reset_password?(client.char)
        return nil
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client) do |char|
          
          if (Roles::Api.is_master_admin?(char))
            client.emit_failure t('login.cant_reset_master_admin_password')
            return
          end
          
          char.change_password(self.new_password)
          char.save!
          client.emit_success t('login.password_reset', :name => char.name)
        end
      end
      
      def log_command
        # Don't log full command for password privacy
        name = cmd.args.nil? ? "" : cmd.args.first("=")
        Global.logger.debug("#{self.class.name} #{client} #{name}")
      end
    end
  end
end
