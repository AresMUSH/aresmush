module AresMUSH
  module Login
    def self.can_access_email?(actor, model)
      return true if actor == model
      actor.has_permission?("manage_login")
    end
    
    def self.can_reset_password?(actor)
      actor.has_permission?("manage_login")
    end
    
    def self.wants_announce(listener, connector)
      return false if !listener
      return true if listener.login_watch == "all"
      return false if listener.login_watch == "none"
      listener.is_friend?(connector)
    end
    
    def self.update_site_info(client, char)
      char.update(last_ip: client.ip_addr)
      char.update(last_hostname: client.hostname.downcase)
      char.update(last_on: Time.now)
    end
    
    def self.is_site_match?(char, ip, hostname)
      char.is_site_match?(ip, hostname)
    end

    def self.terms_of_service
      use_tos = Global.read_config("login", "use_terms_of_service") 
      tos_filename = "game/files/tos.txt"
      return use_tos ? File.read(tos_filename, :encoding => "UTF-8") : nil
    end
    
    def self.check_for_suspect(char)
      suspects = Global.read_config("login", "suspect_sites")
      suspects.each do |s|
        if (Login.is_site_match?(char, s, s))
          Global.logger.warn "SUSPECT LOGIN! #{char.name} from #{char.last_ip} #{char.last_hostname} matches #{s}"
          Jobs::Api.create_job(Global.read_config("login", "suspect_category"), 
            t('login.suspect_login_title'), 
            t('login.suspect_login', :name => char.name, :ip => char.last_ip, :host => char.last_hostname, :match => s), 
            Game.master.system_character)
        end
      end
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