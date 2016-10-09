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
      return false if !listener
      return true if listener.login_watch == "all"
      return false if listener.login_watch == "none"
      listener.is_friend?(connector)
    end
    
    def self.update_site_info(client, char)
      status = char.get_or_create_login_status
      status.last_ip = client.ip_addr
      status.last_hostname = client.hostname.downcase
      status.last_on = Time.now
      status.save
    end
    
    def self.is_site_match?(char, ip, hostname)
      return false if !char.login_status
      char.login_status.is_site_match?(ip, hostname)
    end

    def self.terms_of_service
      use_tos = Global.read_config("connect", "use_terms_of_service") 
      tos_filename = "game/files/tos.txt"
      return use_tos ? File.read(tos_filename, :encoding => "UTF-8") : nil
    end
    
    def self.check_for_suspect(char)
      suspects = Global.read_config("login", "suspect_sites")
      suspects.each do |s|
        if (Login.is_site_match?(char, s, s))
          Global.logger.warn "SUSPECT LOGIN! #{char.name} from #{char.last_ip} #{char.last_hostname} matches #{s}"
          status = char.login_status
          Jobs::Api.create_job(Global.read_config("login", "jobs", "suspect_category"), 
            t('login.suspect_login_title'), 
            t('login.suspect_login', :name => char.name, :ip => status.last_ip, :host => status.last_hostname, :match => s), 
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
  end
end