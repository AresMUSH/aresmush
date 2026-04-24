module AresMUSH
  module Login

    def self.terms_of_service
      tos_text = Global.config_reader.get_text('tos.txt')
      if (!tos_text)
        Global.logger.warn "Can't read terms of service file."
      end
      return tos_text.blank? ? nil : tos_text
    end
    
    # Moved to engine - method stays for backwards compatibility
    def self.is_site_match?(char_ip, char_host, ip, hostname)
      Client.is_site_match?(char_ip, char_host, ip, hostname)
    end
    
    def self.is_online?(char)
      !!Login.find_game_client(char)
    end
    
    def self.is_online_or_on_web?(char)
      Login.find_game_client(char) || Login.find_web_client(char)
    end
    
    def self.is_portal_only?(char)
      !Login.find_game_client(char) && Login.find_web_client(char)
    end
    
    def self.find_game_client(char)
      return nil if !char
      Global.client_monitor.find_game_client(char)
    end
    
    def self.find_web_client(char)
      return nil if !char
      Global.client_monitor.find_web_client(char)
    end
        
    def self.emit_if_logged_in(char, message)
      client = Login.find_game_client(char)
      if (client)
        client.emit message
      end
    end
    
    def self.emit_ooc_if_logged_in(char, message)
      client = Login.find_game_client(char)
      if (client)
        client.emit_ooc message
      end
    end
      
    def self.connect_client_after_login(char, client)
      # Handle reconnect
      existing_client = Login.find_game_client(char)
      client.char_id = char.id
      
      if (existing_client)
        existing_client.emit_ooc t('login.disconnected_by_reconnect')
        existing_client.disconnect

        # Give the disconnect a second to clear first.
        Global.dispatcher.queue_timer(1, "Announce Connection", client) { announce_connection(client, char) }
      else
        announce_connection(client, char)
      end
    end
    
    def self.set_random_password(char)
      password = Login.generate_random_password
      char.change_password(password)
      char.update(login_failures: 0)
      Login.expire_web_login(char)
      password
    end
    
    # Creates a bell notification - does NOT emit any messages to online chars
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
      Login.update_notification_count(char)
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
      
      Login.update_notification_count(char)
    end
    
    def self.count_unread_notifs_for_all_alts(char)
      return if !char
      count = 0
      AresCentral.alts(char).each do |c|
        count += c.unread_notifications.count
      end
      count
    end
    
    def self.update_notification_count(char)
      return if !char

      unread_count = Login.count_unread_notifs_for_all_alts(char)
      Global.client_monitor.notify_web_clients(:notification_update, "#{unread_count}", true) do |c|
        c && AresCentral.is_alt?(c, char)
      end
    end
    
    def self.build_web_site_info(char, viewer)
      # Limit to admins
      return {} if !viewer.is_admin?
      
      matches = Character.all.select { |c| Login.is_site_match?(c.last_ip, 
        c.last_hostname, 
        char.last_ip, 
        char.last_hostname) }
      findsite = matches.map { |m| { name: m.name, ip: m.last_ip, hostname: m.last_hostname } }
      {
        last_online: OOCTime.local_long_timestr(viewer, char.last_on),
        last_ip: char.last_ip,
        last_hostname: char.last_hostname,
        findsite: findsite,
        email: char.login_email
      }
    end
    
    def self.can_boot?(actor)
      # Limit to admins or approved non-admins to prevent trolls from using it.
      return false if !actor
      not_new = actor.has_permission?("manage_login") || actor.is_approved?
      actor.has_permission?("boot") && not_new
    end
    
    def self.build_web_profile_edit_data(char, viewer, is_profile_manager)
      {
        show_pw_tab: Login.can_manage_login?(viewer)
      }
    end
    
    def self.web_last_online_update(char, request)
      # 30 minutes keeps idle times minimal without updating a zillion times for each web request
      if (Time.now - char.last_on > 60 * 30)
        Login.update_site_info(request.ip_addr, request.hostname, char)
      end
    end
  end
end
