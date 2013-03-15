module AresMUSH
  module Login
    def self.create_player(client, name, password, dispatcher)
      return if !validate_create_player(client, name, password)

      player = Player.create_player(name, password)
      client.emit_success(t('login.player_created', :name => name))
      client.player = player
      dispatcher.on_event(:player_created, :client => client)        
    end

    def self.validate_create_player(client, name, password)
      if (name.empty?)
        client.emit_failure(t('login.invalid_create_syntax'))
        return false
      end

      if (password.length < 5)
        client.emit_failure(t('login.password_too_short'))
        return false
      end

      if (Player.exists?(name))
        client.emit_failure(t('login.player_name_taken'))
        return false
      end

      return true
    end
  end
end
