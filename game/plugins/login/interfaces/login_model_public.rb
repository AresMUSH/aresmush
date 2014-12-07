module AresMUSH
  class Character
    def is_guest?
      Login.is_guest?(self)
    end
    
    def change_password(raw_password)
      self.password_hash = Character.hash_password(raw_password)
    end

    def name_and_alias
      if (self.alias.blank?)
        name
      else
        "#{name} (#{self.alias})"
      end
    end
    
    def self.check_password(password)
      return t('validation.password_too_short') if (password.length < 5)
      return t('validation.password_cant_have_equals') if (password.include?("="))
      return nil
    end
    
    def self.check_name(name)
      return t('validation.name_too_short') if (name.length < 2)
      return t('validation.name_contains_invalid_chars') if (name !~ /^[A-Za-z0-9\'\-]+$/)
      return t('validation.name_is_restricted') if (Global.config["names"]["restricted"].include?(name.downcase))
      return t('validation.char_name_taken') if (Character.found?(name))
      return nil
    end
  end  
end