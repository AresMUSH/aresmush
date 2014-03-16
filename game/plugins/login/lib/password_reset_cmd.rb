module AresMUSH
  module Login
    class PasswordResetCmd
      include AresMUSH::Plugin
      
      attr_accessor :name
      attr_accessor :new_password

      # Validators
      must_be_logged_in
      
      # TODO - validate permission

      def want_command?(client, cmd)
        cmd.root_is?("password") && cmd.switch_is?("reset")
      end

      def crack!
        cmd.crack!(/(?<name>[^\=]+)\=(?<password>.+)/)
        self.name = cmd.args.name
        self.new_password = cmd.args.password
      end
      
      def validate_old_password
        return t('dispatcher.invalid_syntax', :command => 'passsword') if self.name_or_old_password.nil?
      end
      
      def validate_new_password
        return t('dispatcher.invalid_syntax', :command => 'passsword') if self.new_password.nil?
        return Login.validate_char_password(self.new_password)
      end
      
      def handle
        char = Character.find_by_name(self.name.normalize)
        
        if (char.nil?)
          client.emit_failure(t("db.no_char_found"))
          return
        end

        char.change_password(self.new_password)
        char.save!
        client.emit_success t('login.password_reset', :name => self.name)
      end
    end
  end
end
