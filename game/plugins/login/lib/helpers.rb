module AresMUSH
  module Login
    def self.can_access_email?(actor, model)
      return true if actor == model
      actor.has_permission?("manage_login")
    end
    
    def self.can_manage_login?(actor)
      actor.has_permission?("manage_login")
    end
    
    def self.can_boot?(actor)
      # Limit to admins or approved non-admins to prevent trolls from using it.
      not_new = actor.has_permission?("manage_login") || actor.is_approved?
      actor.has_permission?("boot") && not_new
    end
    
    def self.wants_announce(listener, connector)
      return false if !listener
      return true if listener.login_watch == "all"
      return false if listener.login_watch == "none"
      listener.is_friend?(connector)
    end
    
    def self.update_site_info(client, char)
      char.update(last_ip: client.ip_addr)
      char.update(last_hostname: client.hostname ? client.hostname.downcase : nil)
      char.update(last_on: Time.now)
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

    def self.terms_of_service
      use_tos = Global.read_config("login", "use_terms_of_service") 
      tos_filename = "game/files/tos.txt"
      return use_tos ? File.read(tos_filename, :encoding => "UTF-8") : nil
    end
    
    def self.check_for_suspect(char)
      suspects = Global.read_config("login", "suspect_sites")
      return false if !suspects
      
      suspects.each do |s|
        if (char.is_site_match?(s, s))
          Global.logger.warn "SUSPECT LOGIN! #{char.name} from #{char.last_ip} #{char.last_hostname} matches #{s}"
          Jobs::Api.create_job(Global.read_config("login", "trouble_category"), 
            t('login.suspect_login_title'), 
            t('login.suspect_login', :name => char.name, :ip => char.last_ip, :host => char.last_hostname, :match => s), 
            Game.master.system_character)
        end
      end
    end
    
    def self.is_banned?(client)
      suspects = Global.read_config("login", "banned_sites")
      return false if !suspects
      
      ip = client.ip_addr
      hostname = client.hostname ? client.hostname.downcase : ""
      
      suspects.each do |s|
        if (Login.is_site_match?(ip, hostname, s, s))
          return true
        end
      end
      return false
    end
    
    def self.guest_role
      Global.read_config("login", "guest_role")
    end
        
    def self.guests
      role = Role.find_one_by_name(Login.guest_role)
      Character.all.select { |c| c.roles.include?(role) }
    end
    
    def self.announce_connection(client, char)
      Global.dispatcher.queue_event CharConnectedEvent.new(client, char)
    end
      
    def self.login_char(char, client)
      # Handle reconnect
      existing_client = char.client
      client.char_id = char.id
      
      if (existing_client)
        existing_client.emit_ooc t('login.disconnected_by_reconnect')
        existing_client.disconnect

        Global.dispatcher.queue_timer(1, "Announce Connection", client) { announce_connection(client, char) }
      else
        announce_connection(client, char)
      end
    end
  end
end