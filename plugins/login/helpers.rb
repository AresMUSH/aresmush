module AresMUSH
  module Login
    mattr_accessor :blacklist
    
    def self.can_access_email?(actor, model)
      return true if actor == model
      actor && actor.has_permission?("manage_login")
    end
    
    def self.can_manage_login?(actor)
      actor && actor.has_permission?("manage_login")
    end
    
    def self.can_login?(actor)
      actor && actor.has_permission?("login")
    end
    
    def self.creation_allowed?
      Global.read_config('login', 'allow_creation')
    end
    
    def self.restricted_login_message
      Global.read_config('login', 'login_not_allowed_message') || ''
    end
    
    def self.can_boot?(actor)
      # Limit to admins or approved non-admins to prevent trolls from using it.
      return false if !actor
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
    
    # Char may be nil
    def self.is_banned?(char, ip_addr, hostname)
      hostname = hostname ? hostname.downcase : "" 
      
      # Admins can never be banned.  Take away their admin privs first!
      return false if char && char.is_admin?

      # Check explicitly banned sites.
      banned = Global.read_config("sites", "banned") || []
      banned.each do |s|
        if (Login.is_site_match?(ip_addr, hostname, s, s))
          return true
        end
      end
      
      # If the character is not approved and proxy ban is enabled, check the proxy list.
      return false if !Global.read_config("sites", "ban_proxies")
      return false if char && char.is_approved?

      if (!Login.blacklist)
        text = Global.config_reader.get_text('blacklist.txt')
        if (text)
          Login.blacklist = text.split("\n")
        else
          Login.blacklist = []
        end
      end
      Login.blacklist.each do |s|
        if (Login.is_site_match?(ip_addr, hostname, s, s))
          return true
        end
      end
      
      return false
    end
    
    def self.guest_role
      Global.read_config("login", "guest_role").to_s
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

      connector = HttpConnector.new      
      resp = connector.get('http://rhostmush.com/blacklist.txt')
      blacklist = resp.body

      if (blacklist)
        blacklist = blacklist.split("\n").select { |b| b != "ip" && !b.empty? }.join("\n")
        File.open(File.join(AresMUSH.game_path, 'text', 'blacklist.txt'), 'w') do |f|
          f.puts blacklist
        end
      end
      # Reset the cache so it reloads next time.
      Login.blacklist = nil
    end
    
    def self.check_login(char, password, ip_addr, hostname)
      if (!Login.can_login?(char))
        return { status: 'error', error: t('login.login_restricted', :reason => Login.restricted_login_message) }
      end
      
      if (char.is_statue?)
        return { status: 'error', error: t('dispatcher.you_are_statue') }
      end

      if (Login.is_banned?(char, ip_addr, hostname))
        return { status: 'error',  error: Login.site_blocked_message }
      end

      password_ok = char.compare_password(password)

      if (!password_ok && char.handle && AresCentral.is_registered?)
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
        
      if (!password_ok)
        Global.logger.info "Failed login attempt #{char.login_failures} to #{char.name} from #{ip_addr}."
        char.update(login_failures: char.login_failures + 1)
        return { status: 'error', error: t('login.password_incorrect') }
      end
      
      Login.update_site_info(ip_addr, hostname, char)
      return { status: 'ok' }
    end
    
    def self.site_blocked_message
      Global.read_config("sites", "ban_proxies") ? 
         t('login.site_blocked_proxies') : 
         t('login.site_blocked')
    end
    
    def self.is_email_valid?(email)
      return true if email.blank?
      if email !~ /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
        return false
      end
      return true
    end
    
    def self.name_taken?(name, enactor = nil)
      return nil if !name

      found = Character.find_one_by_name(name)
      
      # They can have their own name
      return nil if enactor && found == enactor
      
      # Only look for an exact name match.
      if (found && (found.name_upcase == name.upcase || found.alias_upcase == name.upcase))
        return t('validation.char_name_taken')
      end
      
      return nil
    end
  end
end