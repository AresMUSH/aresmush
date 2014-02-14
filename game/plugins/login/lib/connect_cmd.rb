module AresMUSH
  module Login
    class Connect
      include AresMUSH::Plugin

      def want_command?(cmd)
         cmd.root_is?("connect")
      end
      
      def crack!
        cmd.crack!(/(?<name>\S+) (?<password>.+)/)
      end
      
      def validate
        return t("login.already_logged_in") if cmd.logged_in?
        return t('login.invalid_connect_syntax') if (args.name.nil? || args.password.nil?)
        return nil
      end

      def handle
        name = args.name
        password = args.password

        char = Character.find_by_name(name)
        
        if (char.nil?)
          client.emit_failure(t("login.char_not_found"))
          return
        end
        
        if (!char.compare_password(password))
          client.emit_failure(t('login.invalid_password'))
          return 
        end

        client.char = char
        Global.dispatcher.on_event(:char_connected, :client => client)
      end
      
      def log_command(client, cmd)
        # Don't log full command for password privacy
        Global.logger.debug("#{self.class.name} #{client}")
      end
    end
  end
end
