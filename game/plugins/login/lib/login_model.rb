module AresMUSH
  
  class Character

    attribute :login_email
    attribute :login_watch, :default => "friends"
    attribute :login_keepalive, :type => DataType::Boolean, :default => true
    attribute :login_failures, :type => DataType::Integer
    attribute :login_api_token
    attribute :login_api_token_expiry, :type => DataType::Time
    
    attribute :terms_of_service_acknowledged, :type => DataType::Time
    attribute :last_ip
    attribute :last_hostname
    
    def is_site_match?(ip, hostname)
      Login.is_site_match?(self.last_ip, self.last_hostname, ip, hostname)
    end
    
    def self.check_name(name)
      return t('validation.name_must_be_capitalized') if (name[0].downcase == name[0])
      return t('validation.name_too_short') if (name.length < 2)
      return t('validation.name_contains_invalid_chars') if (name !~ /^[A-Za-z0-9\'\-]+$/)
      return t('validation.name_is_restricted') if (Global.read_config("names", "restricted").include?(name.downcase))
      return t('validation.char_name_taken') if (Character.found?(name))
      return nil
    end
    
    def is_valid_api_token?(token)
      return self.login_api_token == token && self.login_api_token_expiry > Time.now
    end
  end  
  
  
  class Game
    attribute :login_activity, :type => DataType::Hash, :default => {}
    attribute :login_activity_samples, :type => DataType::Integer
  end
end