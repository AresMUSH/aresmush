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
    
    # Checks to see if either the IP or hostname is a match with the specified string.
    # For IP we check the first few numbers because they're most meaningful.  
    # For the hostname, it's reversed.
    def is_site_match?(ip, hostname)
      host_search = hostname.chars.last(20).join.to_s.downcase
      ip_search = ip.chars.first(10).join.to_s

      ip = self.last_ip || ""
      host = self.last_hostname || ""
      
      return true if !ip_search.blank? && ip.include?(ip_search)
      return true if !host_search.blank? && host.include?(host_search)
      return false
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
end