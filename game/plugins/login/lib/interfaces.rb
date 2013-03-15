module AresMUSH
  module Login
    
    def self.validate_player_password(client, password)
      if (password.length < 5)
        client.emit_failure(t('login.password_too_short'))
        return false
      end
      return true
    end
    
    def self.validate_player_name(client, name)
      if (name.empty?)
        client.emit_failure(t('login.invalid_create_syntax'))
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
