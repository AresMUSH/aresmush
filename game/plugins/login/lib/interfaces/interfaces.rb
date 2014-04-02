module AresMUSH
  module Login
    
    def self.check_char_password(password)
      return t('login.password_too_short') if (password.length < 5)
      return t('login.password_cant_have_equals') if (password.include?("="))
      return nil
    end
    
    def self.check_char_name(name)
      return t('login.name_too_short') if (name.length < 3)
      return t('login.name_must_be_capitalized') if (name[0].downcase == name[0])
      return t('login.char_name_taken') if (Character.exists?(name))
      return nil
    end
  end
end
