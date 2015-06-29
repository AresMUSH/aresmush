module AresMUSH
  class Character
    def is_guest?
      Login.is_guest?(self)
    end
    
    def client
      Global.client_monitor.find_client(self)
    end
    
    def is_online?
      !self.client.nil?
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