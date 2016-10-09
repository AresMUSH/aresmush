module AresMUSH
  
  class LoginStatus < Ohm::Model
    include ObjectModel
    
    reference :character, "AresMUSH::Character"
    
    attribute :terms_of_service_acknowledged, DataType::Time
    attribute :last_on, DataType::Time
    attribute :last_ip
    attribute :last_hostname
  end
  
  
  class LoginPrefs < Ohm::Model
    include ObjectModel
    
    attribute :email
    attribute :watch

    reference :character, "AresMUSH::Character"
    
    before_create :set_default_login_attributes
    
    def set_default_login_attributes
      self.watch = "all"
    end
  end
  
  class Character
    
    reference :login_status, "AresMUSH::LoginStatus"
    reference :login_prefs, "AresMUSH::LoginPrefs"
    
    def self.check_name(name)
      return t('validation.name_too_short') if (name.length < 2)
      return t('validation.name_contains_invalid_chars') if (name !~ /^[A-Za-z0-9\'\-]+$/)
      return t('validation.name_is_restricted') if (Global.read_config("names", "restricted").include?(name.downcase))
      return t('validation.char_name_taken') if (Character.found?(name))
      return nil
    end
    
    # Checks to see if either the IP or hostname is a match with the specified string.
    # For IP we check the first few numbers because they're most meaningful.  
    # For the hostname, it's reversed.
    def is_site_match?(ip, hostname)
      host_search = hostname.chars.last(20).join.to_s.downcase
      ip_search = ip.chars.first(10).join.to_s
      
      return true if self.last_ip.include?(ip_search)
      return true if self.last_hostname.include?(host_search)
      return false
    end
    
  end  
end