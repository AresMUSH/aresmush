module AresMUSH
  module Login
    class EmailSetCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :email

      def initialize(client, cmd, enactor)
        self.required_args = ['email']
        self.help_topic = 'email'
        super
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
        enactor.email = self.email
        enactor.save!
        client.emit_success t('login.email_set')
      end
    end
  end
end
