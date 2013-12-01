module AresMUSH
  module Login
    class Connect
      include AresMUSH::Plugin

      def want_command?(cmd)
         cmd.root_is?("connect")
      end
      
      # TODO _ Validate if not logged in

      def on_command(client, cmd)      
        cmd.crack!(/(?<name>\S+) (?<password>.+)/)
        
        if (cmd.args.name.nil? || cmd.args.password.nil?)
          client.emit_failure(t('login.invalid_connect_syntax')) 
          return
        end

        name = cmd.args.name
        password = cmd.args.password
        find_result = SingleTargetFinder.find(name, Character)
        
        if (!find_result.found?)
          client.emit_failure(find_result.error)
          return
        end
        
        char = find_result.target
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
