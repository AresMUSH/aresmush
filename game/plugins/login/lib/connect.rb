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

        name = args[:name]
        password = args[:password]
        player = Player.find_one_and_notify(name, client)

        # find_one_and_notify already did the emits on failure.
        return if player.nil?
        
        if (!Player.compare_password(player, password))
          client.emit_failure(t('login.invalid_password'))
          return 
        end

        client.player = player
        container.dispatcher.on_event(:player_connected, :client => client)
      end
    end
  end
end
