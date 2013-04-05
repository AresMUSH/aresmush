module AresMUSH
  module Login
    
    def self.validate_char_password(client, password)
      if (password.length < 5)
        client.emit_failure(t('login.password_too_short'))
        return false
      end
      return true
    end
    
    def self.validate_char_name(client, name)
      if (name.empty?)
        client.emit_failure(t('login.invalid_create_syntax'))
        return false
      end

      if (Character.exists?(name))
        client.emit_failure(t('login.char_name_taken'))
        return false
      end

      return true
    end
  end
end
