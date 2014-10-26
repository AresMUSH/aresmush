module AresMUSH
  class Character
    field :email, :type => String
    field :terms_of_service_acknowledged, :type => Time
    field :watch, :type => String, :default => "all"
    field :password_hash, :type => String

    def is_guest?
      Login.is_guest?(self)
    end
    
    def change_password(raw_password)
      self.password_hash = Character.hash_password(raw_password)
    end

    def compare_password(entered_password)
      hash = BCrypt::Password.new(self.password_hash)
      hash == entered_password
    end
    
    def self.check_password(password)
      return t('validation.password_too_short') if (password.length < 5)
      return t('validation.password_cant_have_equals') if (password.include?("="))
      return nil
    end
    
    def self.check_name(name)
      return t('validation.name_too_short') if (name.length < 2)
      return t('validation.char_name_taken') if (Character.found?(name))
      return t('validation.name_contains_invalid_chars') if (name !~ /^[A-Za-z\'\-]+$/)
      return t('validation.name_is_restricted') if (Global.config["names"]["restricted"].include?(name.downcase))
      return nil
    end
    
    def self.hash_password(password)
      BCrypt::Password.create(password)
    end
    
  end  
end