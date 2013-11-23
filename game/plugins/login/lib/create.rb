module AresMUSH
  module Login
    class Create
      include AresMUSH::Plugin

      def want_anon_command?(cmd)
        cmd.root_is?("create")
      end

      def on_command(client, cmd)      
        cmd.crack!(/(?<name>\S+) (?<password>.+)/)
        
        if (cmd.args.name.nil? || cmd.args.password.nil?)
          client.emit_failure(t('login.invalid_create_syntax'))
          return
        end
        
        name = cmd.args.name
        password = cmd.args.password
        
        return if !Login.validate_char_name(client, name)
        return if !Login.validate_char_password(client, password)
        
        create_char_and_login(client, name, password)
      end
      
      def create_char_and_login(client, name, password)
        char = Character.create_char(name, password)
        client.emit_success(t('login.created_and_logged_in', :name => name))
        client.char = char
        container.dispatcher.on_event(:char_created, :client => client)        
      end
      
      def log_command(client, cmd)
        # Don't log full command for privacy
        logger.debug("#{self.class.name} #{client}")
      end      
    end
  end
end
