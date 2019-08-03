module AresMUSH
  module Login
    def self.can_access_email?(actor, model)
      return true if actor == model
      actor.has_permission?("manage_login")
    end
    
    def self.can_manage_login?(actor)
      actor.has_permission?("manage_login")
    end
    
    def self.can_login?(actor)
      actor.has_permission?("login")
    end
    
    def self.creation_allowed?
      Global.read_config('login', 'allow_creation')
    end
    
    def self.restricted_login_message
      Global.read_config('login', 'login_not_allowed_message') || ''
    end
    
    def self.can_boot?(actor)
      # Limit to admins or approved non-admins to prevent trolls from using it.
      not_new = actor.has_permission?("manage_login") || actor.is_approved?
      actor.has_permission?("boot") && not_new
    end
    
    def self.wants_announce(listener, connector)
      return false if !listener
      return true if listener.login_watch == "all"
      return true if listener.login_watch == "new" && connector.status == "NEW"
      return false if listener.login_watch == "none"
      listener.is_friend?(connector)
    end
    
    def self.update_site_info(ip_addr, hostname, char)
      hostname = hostname ? hostname.downcase : nil
      char.update(last_ip: ip_addr)
      char.update(last_hostname: hostname)
      char.update(last_on: Time.now)
    end
    
    def self.check_for_suspect(char)
      suspects = Global.read_config("sites", "suspect")
      return false if !suspects
      
      suspects.each do |s|
        if (char.is_site_match?(s, s))
          Global.logger.warn "SUSPECT LOGIN! #{char.name} from #{char.last_ip} #{char.last_hostname} matches #{s}"
          Jobs.create_job(Jobs.trouble_category, 
            t('login.suspect_login_title'), 
            t('login.suspect_login', :name => char.name, :ip => char.last_ip, :host => char.last_hostname, :match => s), 
            Game.master.system_character)
        end
      end
    end
    
    def self.is_banned?(ip_addr, hostname)
      suspects = Global.read_config("sites", "banned") || []
      
      if (Global.read_config("sites", "ban_proxies"))
        blacklist_file = File.join(AresMUSH.game_path, "text", "blacklist.txt")
        if (File.exists?(blacklist_file))
          blacklist = File.readlines(blacklist_file)
          suspects.concat blacklist
        end
      end
            
      return false if suspects.empty?
      
      hostname = hostname ? hostname.downcase : "" 
      
      suspects.each do |s|
        if (Login.is_site_match?(ip_addr, hostname, s, s))
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
      return [] if !role
      Character.all.select { |c| c.roles.include?(role) }
    end
    
    def self.announce_connection(client, char)
      Global.dispatcher.queue_event CharConnectedEvent.new(client, char.id)
    end
    
    def self.is_name_restricted?(name)
      return true if !name
      restricted_names = Global.read_config("names", "restricted") || []
      restricted_names = restricted_names.map { |r| r.downcase }
      restricted_names.include?(name.downcase)  
    end
    
    # Can take awhile - call from an Engine.spawn
    def self.update_blacklist
      return if (!Global.read_config("sites", "ban_proxies"))
      Global.logger.debug "Updating blacklist from rhost.com."
      blacklist = Net::HTTP.get('rhostmush.com', '/blacklist.txt')
      if (blacklist)
        blacklist = blacklist.split("\n").select { |b| b != "ip" && !b.empty? }.join("\n")
        File.open(File.join(AresMUSH.game_path, 'text', 'blacklist.txt'), 'w') do |f|
          f.puts blacklist
        end
      end
    end
    
    def self.check_login(char, password, ip_addr, hostname)
      if (!Login.can_login?(char))
        return { status: 'error', error: t('login.login_restricted', :reason => Login.restricted_login_message) }
      end
      
      if (char.is_statue?)
        return { status: 'error', error: t('dispatcher.you_are_statue') }
      end

      if (Login.is_banned?(ip_addr, hostname))
        return { status: 'error',  error: t('login.site_blocked') }
      end

      if (char.handle && AresCentral.is_registered?)
        AresMUSH.with_error_handling(nil, "AresCentral forgotten password.") do
          Global.logger.info "Checking AresCentral for forgotten password."

          connector = AresCentral::AresConnector.new
          response = connector.reset_password(char.handle.handle_id, password, char.id.to_s)

          if (response.is_success? && response.data["matched"])
            char.change_password password
	      	  char.update(login_failures: 0)
            return { status: 'unlocked' }
          end
        end
      end
      
      if (char.login_failures > 5)
        Global.logger.info "#{char.name} locked due to repeated login failures."
        return { status: 'error', error: t('login.password_locked') }
      end
        
      if (!char.compare_password(password))
        Global.logger.info "Failed login attempt #{char.login_failures} to #{char.name} from #{ip_addr}."
        char.update(login_failures: char.login_failures + 1)
        return { status: 'error', error: t('login.password_incorrect') }
      end
      
      return { status: 'ok' }
    end
  end
end