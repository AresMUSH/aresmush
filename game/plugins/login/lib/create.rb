module AresMUSH
  module Login
    class Create
      include AresMUSH::Plugin

      def want_anon_command?(cmd)
        cmd.root_is?("create")
      end

      def on_command(client, cmd)      
        args = cmd.crack_args!(/(?<name>\S+) (?<password>.+)/)
        
        if (args.nil?)
          client.emit_failure(t('login.invalid_create_syntax'))
          return
        end
        
        name = args[:name]
        password = args[:password]
        
        Login.create_player(client, name, password, container.dispatcher)
      end
    end
  end
end
