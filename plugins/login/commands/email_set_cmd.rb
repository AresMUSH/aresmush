module AresMUSH
  module Login
    class EmailSetCmd
      include CommandHandler
      
      attr_accessor :email
      
      def parse_args
        self.email = trim_arg(cmd.args)
      end
      
      def check_email_format
        if !Login.is_email_valid?(self.email)
          return t('login.invalid_email_format')
        end
        return nil
      end
      
      def handle      
        enactor.update(login_email: self.email)
        client.emit_success t('login.email_set')
      end
    end
  end
end
