module AresMUSH
  module Login
    class PasswordResetCmd
      include AresMUSH::Plugin
      
      attr_accessor :name
      attr_accessor :new_password

      # Validators
      must_be_logged_in
      argument_must_be_present "name", "password"
      argument_must_be_present "new_password", "password"
      
      # TODO - check permission

      def want_command?(client, cmd)
        cmd.root_is?("password") && cmd.switch_is?("reset")
      end

      def crack!
        cmd.crack!(/(?<name>[^\=]+)\=(?<password>.+)/)
        self.name = trim_input(cmd.args.name)
        self.new_password = cmd.args.password
      end
      
      def check_new_password
        return t('dispatcher.invalid_syntax', :command => 'passsword') if self.new_password.nil?
        return Login.check_char_password(self.new_password)
      end
      
      def handle
        char = Character.find_by_name(self.name)
        
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
