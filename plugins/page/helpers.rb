module AresMUSH
  module Page
    
    def self.format_page_indicator(char)
      t('page.page_indicator',
      :start_marker => Global.read_config("page", "page_start_marker") || "<",
      :end_marker => Global.read_config("page", "page_end_marker") || "<",
      :color => Page.page_color(char) )
    end
    
    def self.format_recipient_indicator(recipients)
      names = []
      recipients.sort_by { |r| r.name }.each do |r|
        client = Login.find_client(r)
        if (!client)
          if (Login.find_web_client(r))
            names << "#{r.name}#{Website.web_char_marker}"
          else
            names << "#{r.name}<#{t('global.offline_status')}>"
          end
        elsif (r.page_do_not_disturb)
          names << "#{r.name}<#{t('page.dnd_status')}>"
        elsif (r.is_afk?)
          names << "#{r.name}<#{t('global.afk_status')}>"
        elsif Status.is_idle?(client)
          time = TimeFormatter.format(client.idle_secs)
          names << "#{r.name}<#{time}>"
        else
          names << r.name
        end
      end
      return t('page.recipient_indicator', :recipients => names.join(", "))
    end
    
    # NO LONGER USED.  Keeping for reference.
    def self.send_afk_message(client, other_client, other_char)
      if (!other_client)
        #client.emit_ooc t('page.recipient_is_offline', :name => other_char.name)
        return
      elsif (other_char.is_afk)
        afk_message = ""
        if (other_char.afk_display)
          afk_message = "(#{other_char.afk_display})"
        end
        afk_message = t('page.recipient_is_afk', :name => other_char.name, :message => afk_message)
        client.emit_ooc afk_message
        other_client.emit_ooc afk_message
      elsif (Status.is_idle?(other_client))
        time = TimeFormatter.format(other_client.idle_secs)
        afk_message = t('page.recipient_is_idle', :name => other_char.name, :time => time)
        client.emit_ooc afk_message
        other_client.emit_ooc afk_message
      end
    end
  
    def self.page_color(char)
      char.page_color || Global.read_config("page", "page_color")
    end
    
    # Client may be nil if sent via portal.
    def self.send_page(enactor, recipients, message, client)
      message = PoseFormatter.format(enactor.name_and_alias, message)
      everyone = [enactor].concat(recipients).uniq
      recipient_names = Page.format_recipient_indicator(recipients)
      
      # Create the db entry
      thread = Page.find_thread(everyone)
      if (thread)
        Page.mark_thread_unread(thread)
      else
        thread = PageThread.create
        everyone.each do |c|
          thread.characters.add c
        end
      end
      
      PageMessage.create(author: enactor, message: message, page_thread: thread)
            
      # Send to the enactor.
      if (client)
        client.emit t('page.to_sender', 
          :pm => Page.format_page_indicator(enactor),
          :autospace => Scenes.format_autospace(enactor, enactor.page_autospace), 
          :recipients => recipient_names, 
          :message => message)
      end
      Page.mark_thread_read(thread, enactor)
      
      # Send to the recipients.
      recipients.each do |recipient|
        recipient_client = Login.find_client(recipient)
        if (recipient_client && !recipient.page_do_not_disturb)
          recipient_client.emit t('page.to_recipient', 
            :pm => Page.format_page_indicator(recipient),
            :autospace => Scenes.format_autospace(enactor, recipient.page_autospace), 
            :recipients => recipient_names, 
            :message => message)
          Page.mark_thread_read(thread, recipient)
        end
        #if (client)
        #  Page.send_afk_message(client, recipient_client, recipient)
        #end
      end

      everyone.each do |char| 
        next if char == enactor   
        Login.notify(char, :pm, t('page.new_pm', :thread => thread.title_without_viewer(char)), thread.id, "", false)
      end
      
      # Can't use notify_web_clients here because the notification is different for each person.
      Global.dispatcher.spawn("Page notification", nil) do
        everyone.each do |char|    
          title = thread.title_without_viewer(char)
          data = {
            id: thread.id,
            key: thread.id,
            title: title,
            author: {name: enactor.name, icon: Website.icon_for_char(enactor), id: enactor.id},
            message: Website.format_markdown_for_html(message),
            is_page: true
          }
                  
          clients = Global.client_monitor.clients.select { |client| client.web_char_id == char.id }
          clients.each do |client|
            client.web_notify :new_page, "#{data.to_json}", true
          end
        end
      end
        
      thread
    end
    
    def self.find_thread(chars)
      PageThread.all.select { |t| (t.characters.map { |c| c.id }.sort == chars.map { |c| c.id }.sort) }.first
    end
    
    def self.thread_for_names(names)
      chars = []
      names.each do |name|
        char = Character.named(name)
        if (!char)
          return nil
        end      
        chars << char
      end
      Page.find_thread(chars)
    end
    
    def self.is_thread_unread?(thread, char)
      tracker = char.get_or_create_read_tracker
      tracker.is_page_thread_unread?(thread)
    end
    
    def self.mark_thread_read(thread, char)      
      tracker = char.get_or_create_read_tracker
      tracker.mark_page_thread_read(thread)
      Login.mark_notices_read(char, :pm, thread.id)
    end
    
    def self.mark_thread_unread(thread, except_for_char = nil)
      chars = Character.all.select { |c| !Page.is_thread_unread?(thread, c) }
      chars.each do |char|
        next if except_for_char && char == except_for_char
        tracker = char.get_or_create_read_tracker
        tracker.mark_page_thread_unread(thread)
      end
    end
    
    def self.has_unread_page_threads?(char)
      return false if !char
      char.page_threads.any? { |t| Page.is_thread_unread?(t, char) }
    end
    
    def self.report_page_abuse(enactor, thread, messages, reason)
      log = messages.map { |m| "  [#{OOCTime.local_long_timestr(enactor, m.created_at)}] #{m.message}"}.join("%R")
      
      body = t('page.page_reported_body', :name => thread.title_without_viewer(enactor), :reporter => enactor.name)
      body << reason
      body << "%R"
      body << log
      Jobs.create_job(Jobs.trouble_category, t('page.page_reported_title'), body, Game.master.system_character)
    end
  end

end