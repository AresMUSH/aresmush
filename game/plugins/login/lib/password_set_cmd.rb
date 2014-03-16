module AresMUSH
  module Login
    class PasswordSetCmd
      include AresMUSH::Plugin
      
      attr_accessor :name_or_old_password
      attr_accessor :new_password

      # Validators
      must_be_logged_in

      def want_command?(client, cmd)
        cmd.root_is?("password")
      end

      def crack!
        cmd.crack!(/(?<name>[^\=]+)\=(?<password>.+)/)
        self.name_or_old_password = cmd.args.name
        self.new_password = cmd.args.password
      end
      
      def validate_old_password
        return t('login.missing_password') if self.name_or_old_password.nil?
      end
      
      def validate_new_password
        return t('login.missing_password') if self.new_password.nil?
        return Login.validate_char_password(self.new_password)
      end
      
      def handle
        char = Character.find_by_name(self.name_or_old_password.normalize)
        
        if (char.nil?)
          handle_change_own_password
        else
          handle_change_other_password(char)
        end
      end
      
      def handle_change_own_password
        char = client.char
        if (!char.compare_password(self.name_or_old_password))
          client.emit_failure(t('login.password_incorrect'))
          return 
        end
        char.change_password(self.new_password)
        char.save!
        client.emit_success t('login.password_changed')
      end
      
      def handle_change_other_password(char)
        # TODO - check permission
        char.change_password(self.new_password)
        char.save!
        client.emit_success t('login.password_reset', :name => self.name_or_old_password)
      end
    end
  end
end
