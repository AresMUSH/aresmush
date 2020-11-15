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
    attribute :last_on, :type => DataType::Time
    
    attribute :notices_events, :type => DataType::Boolean, :default => true
  
    attribute :onconnect_commands, :type => DataType::Array, :default => [ 'forum/scan' ]
  
    collection :login_notices, "AresMUSH::LoginNotice"
    
    before_delete :cleanup_login
    
    def unread_notifications
      self.login_notices.find(is_unread: true)
    end
    
    def cleanup_login
      self.login_notices.each { |n| n.delete }
    end
    
    def is_guest?
      self.has_any_role?(Login.guest_role)
    end
    
    def is_coder?
      self.has_role?("coder")
    end

    def is_site_match?(ip, hostname)
      Login.is_site_match?(self.last_ip, self.last_hostname, ip, hostname)
    end
    
    # Overrides the default engine name checking behavior.  Be sure not to have multiple
    # plugins trying to override this same method.
    def self.check_name(name)
      return t('validation.name_too_short') if (name.length < 2)
      return t('validation.name_contains_invalid_chars') if (name !~ /^[A-Za-z0-9\'\-]+$/)
      return t('validation.name_is_restricted') if Login.is_name_restricted?(name)
      return nil
    end
    
    def is_valid_api_token?(token)
      return false if !token
      return false if !self.login_api_token
      return false if !self.login_api_token_expiry
      val = self.login_api_token == token && !self.login_token_expired?
      return val
    end
    
    def login_token_expired?
      return true if !self.login_api_token
      return true if !self.login_api_token_expiry
      self.login_api_token_expiry < Time.now
    end
    
    def set_login_token
      self.update(login_api_token: "#{SecureRandom.uuid}")
      # 30 days, plus 8 hours so it doesn't expire during their prime-time
      self.update(login_api_token_expiry: Time.now + (86400 * 30) + (60*60*8))
    end
    
    def extend_login_token
      self.update(login_api_token_expiry: Time.now + (86400 * 30) + (60*60*8))
    end
    
    def token_secs_remaining
      self.login_api_token_expiry - Time.now
    end
    
  end  
end