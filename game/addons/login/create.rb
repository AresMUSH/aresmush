module AresMUSH
  module Login
    class Create
      include AresMUSH::Addon

      def commands
        { "create" => "create (?<name>\\S+) (?<password>\\S+)" } 
      end

      def on_player_command(client, cmd)
        name = cmd[:name]
        password = cmd[:password]

        # TODO: Find by alias too
        existing_player = Player.find_by_name(name)
        if (!existing_player.nil?)
          client.emit_failure(t('login.player_name_taken'))
          # TODO: This is just temp until the connect command is done
          client.player = existing_player[0]
        else
          # TODO: Encrypt password
          # TODO: Specs
          player = Player.create(name, password)
          client.emit_success(t('login.player_created', :name => name))
          client.player = player
        end
      end
    end
  end
end
