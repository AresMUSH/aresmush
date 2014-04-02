module AresMUSH
  module Login
    class PasswordSetCmd
      include AresMUSH::Plugin
      
      attr_accessor :old_password
      attr_accessor :new_password

      # Validators
      must_be_logged_in
      argument_must_be_present "old_password", "password"

      def want_command?(client, cmd)
        cmd.root_is?("password") && cmd.switch_is?("set")
      end

      def crack!
        cmd.crack!(/(?<old_password>[^\=]+)\=(?<new_password>.+)/)
        self.old_password = cmd.args.old_password
        self.new_password = cmd.args.new_password
      end
      
      def check_new_password
        return t('dispatcher.invalid_syntax', :command => 'passsword') if self.new_password.nil?
        return Login.check_char_password(self.new_password)
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
    end
  end
end
