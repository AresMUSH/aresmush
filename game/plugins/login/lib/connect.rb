module AresMUSH
  module Login
    class Connect
      include AresMUSH::Plugin

      def want_anon_command?(cmd)
        cmd.root_is?("connect")
      end

      def on_command(client, cmd)      
        args = cmd.crack_args!(/(?<name>\S+) (?<password>.+)/)

        if (args.nil?)
          client.emit_failure(t('login.invalid_connect_syntax')) 
          return
        end

        name = args.name
        password = args.password
        char = Character.find_one_and_notify(name, client)

        # find_one_and_notify already did the emits on failure.
        return if char.nil?
        
        if (!Character.compare_password(char, password))
          client.emit_failure(t('login.invalid_password'))
          return 
        end

        client.char = char
        container.dispatcher.on_event(:char_connected, :client => client)
      end
      
      def log_command(client, cmd)
        # Don't log full command for privacy
        logger.debug("#{self.class.name} #{client}")
      end
    end
  end
end
