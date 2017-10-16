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
    
    def self.check_for_suspect(char)
      suspects = Global.read_config("login", "suspect_sites")
      return false if !suspects
      
      suspects.each do |s|
        if (char.is_site_match?(s, s))
          Global.logger.warn "SUSPECT LOGIN! #{char.name} from #{char.last_ip} #{char.last_hostname} matches #{s}"
          Jobs.create_job(Global.read_config("login", "trouble_category"), 
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
      Global.dispatcher.queue_event CharConnectedEvent.new(client, char.id)
    end
  end
end