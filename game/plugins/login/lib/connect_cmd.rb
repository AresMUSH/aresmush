module AresMUSH
  module Login
    class ConnectCmd
      include CommandHandler
      include CommandWithoutSwitches

      attr_accessor :charname, :password
      
      def crack!
        self.charname = cmd.args ? trim_input(cmd.args.before(" ")) : nil
        self.password = cmd.args ? cmd.args.after(" ") : nil
      end
      
      def check_for_guest_or_password
        return t('dispatcher.invalid_syntax', :command => 'connect') if !self.password || !self.charname
        return nil
      end
      
      def check_not_already_logged_in
        return t("login.already_logged_in") if client.logged_in?
        return nil
      end

      def handle
        return if self.charname.downcase == "guest"
        
        ClassTargetFinder.with_a_character(self.charname, client, enactor) do |char|
          if (!char.compare_password(password))
            client.emit_failure(t('login.password_incorrect'))
            return 
          end

          Login.login_char(char, client)          
        end
      end
      
      def log_command
        # Don't log full command for password privacy
        Global.logger.debug("#{self.class.name} #{client}")
      end
    end
  end
end
