module AresMUSH
  module Login
    
    def self.validate_char_password(password)
      return t('login.password_too_short') if (password.length < 5)
      return t('login.password_cant_have_equals') if (password.include?("="))
      return nil
    end
    
    def self.validate_char_name(name)
      return t('login.name_too_short') if (name.length < 3)
      return t('login.char_name_taken') if (Character.exists?(name))
      return nil
    end
  end
end
