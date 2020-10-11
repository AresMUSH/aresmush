module AresMUSH
  module Login

    def self.terms_of_service
      tos_text = Global.config_reader.get_text('tos.txt')
      if (!tos_text)
        Global.logger.warn "Can't read terms of service file."
      end
      return tos_text.blank? ? nil : tos_text
    end
    
    # Checks to see if either the IP or hostname is a match with the specified string.
    # For IP we check the first few numbers because they're most meaningful.  
    # For the hostname, it's reversed.
    def self.is_site_match?(char_ip, char_host, ip, hostname)
      host_search = "#{hostname}".chars.last(20).join.to_s.downcase
      ip_search = "#{ip}".chars.first(10).join.to_s

      ip = char_ip || ""
      host = char_host || ""
      
      return true if !ip_search.blank? && ip.include?(ip_search)
      return true if !host_search.blank? && host.include?(host_search)
      return false
    end
    
    def self.is_online?(char)
      !!Login.find_client(char)
    end
    
    def self.is_online_or_on_web?(char)
      Login.find_client(char) || Login.find_web_client(char)
    end
    
    def self.is_portal_only?(char)
      !Login.find_client(char) && Login.find_web_client(char)
    end
    
    def self.find_client(char)
      return nil if !char
      Global.client_monitor.find_client(char)
    end
    
    def self.find_web_client(char)
      return nil if !char
      Global.client_monitor.find_web_client(char)
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
      char.update(login_failures: 0)

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
      password = (0...15).map{ charset.to_a[rand(charset.size)] }.join
      char.change_password(password)
      char.update(login_api_token: '')
      char.update(login_api_token_expiry: Time.now - 86400*5)
      password
    end
    
    def self.notify(char, type, message, reference_id, data = "", notify_if_online = true)
      unless notify_if_online
        status = Website.activity_status(char)
        return if status == 'game-active'
      end
      
      # Check for a duplicate notification from today.
      key = "#{type}|#{message}|#{reference_id}|#{Time.now.yday}"
      existing = char.login_notices.select { |n| "#{n.type}|#{n.message}|#{n.reference_id}|#{n.timestamp.yday}" == key }.first
      if (existing)
        # Already an existing unread notice - update the time but return before we send a count update to the website.
        if (existing.is_unread?)
          existing.update(timestamp: Time.now)
          return
        # Existing read notice - update the time and mark unread
        else
          existing.update(is_unread: true, timestamp: Time.now)
        end
      else
        LoginNotice.create(character: char, type: type, message: message, data: data, reference_id: reference_id, is_unread: true, timestamp: Time.now)
      end
      Global.client_monitor.notify_web_clients(:notification_update, "#{char.unread_notifications.count}", true) do |c|
        c == char 
      end
    end
    
    def self.mark_notices_read(char, type, reference_id = nil)
      return if !char
      
      if (reference_id)
        notices = char.login_notices.find(is_unread: true).select { |n| n.type == "#{type}" && n.reference_id == "#{reference_id}"}
      else
        notices = char.login_notices.find(is_unread: true).select { |n| n.type == "#{type}" }
      end
      
      notices.each do |n|
        n.update(is_unread: false)
      end
    end
    
    def self.boot_char(bootee, boot_message)
      status = Website.activity_status(bootee)
      if (status == 'offline')
        return t('login.cant_boot_disconnected_player')
      end
      
      # Boot from game
      boot_client = Login.find_client(bootee)
      if (boot_client)
        boot_client.emit_failure boot_message
        boot_client.disconnect
      end
      
      # Boot from portal
      bootee.update(login_api_token: nil)
      
      return nil
    end
    
    def self.build_web_site_info(char, viewer)
      matches = Character.all.select { |c| Login.is_site_match?(c.last_ip, 
        c.last_hostname, 
        char.last_ip, 
        char.last_hostname) }
      findsite = matches.map { |m| { name: m.name, ip: m.last_ip, hostname: m.last_hostname } }
      {
        last_online: OOCTime.local_long_timestr(viewer, char.last_on),
        last_ip: char.last_ip,
        last_hostname: char.last_hostname,
        findsite: findsite
      }
    end
  end
end
