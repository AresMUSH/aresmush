module AresMUSH
  module Login
    class EmailSetCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :email

      def initialize
        self.required_args = ['email']
        self.help_topic = 'email'
        super
      end
            
      def want_command?(client, cmd)
        cmd.root_is?("email") && cmd.switch_is?("set")
      end

      def crack!
        self.email = trim_input(cmd.args)
      end

      def check_email_format
        if self.email !~ /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
          return t('login.invalid_email_format')
        end
        return nil
      end
      
      def handle      
        client.char.email = self.email
        client.char.save!
        client.emit_success t('login.email_set')
      end
    end
  end
end
