module AresMUSH
  module Login

    def self.terms_of_service
      use_tos = Global.read_config("login", "use_terms_of_service") 
      tos_filename = "game/text/tos.txt"
      return use_tos ? File.read(tos_filename, :encoding => "UTF-8") : nil
    end
    
    # Checks to see if either the IP or hostname is a match with the specified string.
    # For IP we check the first few numbers because they're most meaningful.  
    # For the hostname, it's reversed.
    def self.is_site_match?(char_ip, char_host, ip, hostname)
      host_search = hostname.chars.last(20).join.to_s.downcase
      ip_search = ip.chars.first(10).join.to_s

      ip = char_ip || ""
      host = char_host || ""
      
      return true if !ip_search.blank? && ip.include?(ip_search)
      return true if !host_search.blank? && host.include?(host_search)
      return false
    end
    
    def self.is_online?(char)
      !!Login.find_client(char)
    end
    
    def self.find_client(char)
      Global.client_monitor.find_client(char)
    end
        
    def self.emit_if_logged_in(char, message)
      client = find_client(char)
      if (client)
        client.emit message
      end
    end
    
    def self.emit_ooc_if_logged_in(char, message)
      client = find_client(char)
      if (client)
        client.emit_ooc message
      end
    end
      
    def self.login_char(char, client)
      # Handle reconnect
      existing_client = Login.find_client(char)
      client.char_id = char.id
      
      if (existing_client)
        existing_client.emit_ooc t('login.disconnected_by_reconnect')
        existing_client.disconnect

        Global.dispatcher.queue_timer(1, "Announce Connection", client) { announce_connection(client, char) }
      else
        announce_connection(client, char)
      end
    end
      
    def self.set_random_password(char)
      charset = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
      password = (0...10).map{ charset.to_a[rand(charset.size)] }.join
      char.change_password(password)
      password
    end
  end
end
