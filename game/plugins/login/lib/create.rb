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
        
        return if !Login.validate_player_name(client, name)
        return if !Login.validate_player_password(client, password)
        
        create_player_and_login(client, name, password)
      end
      
      def create_player_and_login(client, name, password)
        player = Player.create_player(name, password)
        client.emit_success(t('login.created_and_logged_in', :name => name))
        client.player = player
        container.dispatcher.on_event(:player_created, :client => client)        
      end
    end
  end
end
