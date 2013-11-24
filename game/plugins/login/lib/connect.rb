module AresMUSH
  module Login
    class Connect
      include AresMUSH::Plugin

      def want_anon_command?(cmd)
        cmd.root_is?("connect")
      end

      def on_command(client, cmd)      
        cmd.crack!(/(?<name>\S+) (?<password>.+)/)
        
        if (cmd.args.name.nil? || cmd.args.password.nil?)
          client.emit_failure(t('login.invalid_connect_syntax')) 
          return
        end

        name = cmd.args.name
        password = cmd.args.password
        char = SingleTargetFinder.find(name, Character, client)

        # find_one_and_notify already did the emits on failure.
        return if char.nil?
        
        if (!Character.compare_password(char, password))
          client.emit_failure(t('login.invalid_password'))
          return 
        end

        client.char = char
        Global.dispatcher.on_event(:char_connected, :client => client)
      end
      
      def log_command(client, cmd)
        # Don't log full command for privacy
        Global.logger.debug("#{self.class.name} #{client}")
      end
    end
  end
end
