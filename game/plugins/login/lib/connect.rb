module AresMUSH
  module Login
    class Connect
      include AresMUSH::Plugin

      def want_anon_command?(cmd)
        cmd.root_is?("connect")
      end

      def on_command(client, cmd)      
        args = cmd.crack_args!(/(?<name>\S+) (?<password>\S+)/)

        if (args.nil?)
          client.emit_failure(t('login.invalid_connect_syntax')) 
          return
        end

        name = args[:name]
        password = args[:password]
        existing_players = Player.find_by_name(name)

        if (existing_players.empty?)
          client.emit_failure(t('login.unrecognized_player')) 
          return 
        end
        
        if (existing_players.count != 1)
          client.emit_failure(t('login.ambiguous_player')) 
          return
        end

        player = existing_players[0]
        if (!Player.compare_password(player, password))
          client.emit_failure(t('login.invalid_password'))
          return 
        end

        client.player = player
        client.emit_success(t('login.welcome'))
        container.dispatcher.on_event(:player_connected, :client => client)
      end
    end
  end
end
