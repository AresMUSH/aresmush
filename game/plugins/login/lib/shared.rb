module AresMUSH
  module Login
    def self.can_access_email?(actor, model)
      return true if actor == model
      return actor.has_any_role?(Global.read_config("login", "roles", "can_access_email"))
    end
    
    def self.can_reset_password?(actor)
      return actor.has_any_role?(Global.read_config("login", "roles", "can_reset_password"))
    end
    
    def self.wants_announce(listener, connector)
      return false if listener.nil?
      return true if listener.watch == "all"
      return false if listener.watch == "none"
      return true if listener.has_friended_char?(connector)
      listener.has_friended_handle?(connector) && connector.handle_visible_to?(listener)
    end
    
    def self.update_site_info(client)
      client.char.last_ip = client.ip_addr
      client.char.last_hostname = client.hostname.downcase
      client.char.save!
    end
    
    def self.check_for_suspect(char)
      suspects = Global.read_config("login", "suspect_sites")
      suspects.each do |s|
        if (char.is_site_match?(s, s))
          Global.logger.warn "SUSPECT LOGIN! #{char.name} from #{char.last_ip} #{char.last_hostname} matches #{s}"
          Jobs.create_job(Global.read_config("login", "jobs", "suspect_category"), 
            t('login.suspect_login_title'), 
            t('login.suspect_login', :name => char.name, :ip => char.last_ip, :host => char.last_hostname, :match => s), 
            Game.master.system_character)
        end
      end
    end
    
    def self.guest_role
      Global.read_config("login", "guest_role")
    end
    
    def self.is_guest?(char)
      char.has_any_role?(Login.guest_role)
    end
    
    def self.guests
      Character.where(:roles.in => [ Login.guest_role ]).all
    end
  end
end