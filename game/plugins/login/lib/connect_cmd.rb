module AresMUSH
  module Login
    class ConnectCmd
      include AresMUSH::Plugin

      attr_accessor :charname, :password
      
      # Validators
      no_switches
      argument_must_be_present "charname", "connect"
      argument_must_be_present "password", "connect"
      
      def want_command?(client, cmd)
        cmd.root_is?("connect")
      end
      
      def crack!
        cmd.crack!(/(?<name>[\S]+) (?<password>.+)/)
        self.charname = trim_input(cmd.args.name)
        self.password = cmd.args.password
      end
      
      def check_not_already_logged_in
        return t("login.already_logged_in") if client.logged_in?
        return nil
      end

      def handle
        ClassTargetFinder.with_a_character(self.charname, client) do |char|
          if (!char.compare_password(password))
            client.emit_failure(t('login.password_incorrect'))
            return 
          end

          client.char = char
          Global.dispatcher.on_event(:char_connected, :client => client)
        end
      end
      
      def log_command
        # Don't log full command for password privacy
        Global.logger.debug("#{self.class.name} #{client}")
      end
    end
  end
end
