module AresMUSH
  module Login
    
    def self.validate_char_password(password)
      return t('login.password_too_short') if (password.length < 5)
      return nil
    end
    
    def self.validate_char_name(name)
      return t('login.invalid_create_syntax') if (name.empty?)
      return t('login.char_name_taken') if (Character.exists?(name))
      return nil
    end
  end
end
