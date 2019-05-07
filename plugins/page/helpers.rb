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
          names << "#{r.name}<#{t('page.offline_status')}>"
        elsif (r.is_afk?)
          names << "#{r.name}<#{t('page.afk_status')}>"
        elsif Status.is_idle?(client)
          time = TimeFormatter.format(client.idle_secs)
          names << "#{r.name}<#{time}>"
        else
          names << r.name
        end
      end
      return t('page.recipient_indicator', :recipients => names.join(", "))
    end
    
    def self.add_to_monitor(char, monitor_name, message)
      monitor = char.page_monitor
        
      if (!monitor[monitor_name])
        monitor[monitor_name] = []
      end
        
      if (monitor[monitor_name].count > 30)
        monitor[monitor_name].shift
      end
      monitor[monitor_name] << "#{Time.now} #{message}"
      char.update(page_monitor: monitor)
    end
    
  
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
      thread_name = Page.generate_thread_name(everyone)
      recipient_names = Page.format_recipient_indicator(recipients)
      
      # Send to the enactor.
      if (client)
        client.emit t('page.to_sender', 
          :pm => Page.format_page_indicator(enactor),
          :autospace => Scenes.format_autospace(enactor, enactor.page_autospace), 
          :recipients => recipient_names, 
          :message => message)
      end

      PageMessage.create(author: enactor, character: enactor, message: message, thread_name: thread_name)
      
      # Send to the recipients.
      
      recipients.each do |recipient|
        recipient_client = Login.find_client(recipient)
        if (recipient_client)
          recipient_client.emit t('page.to_recipient', 
            :pm => Page.format_page_indicator(recipient),
            :autospace => Scenes.format_autospace(enactor, recipient.page_autospace), 
            :recipients => recipient_names, 
            :message => message)
        end
        #if (client)
        #  Page.send_afk_message(client, recipient_client, recipient)
        #end
        
        if (recipient != enactor)
          PageMessage.create(author: enactor, character: recipient, message: message, thread_name: thread_name)
        end
      end
      
      Global.dispatcher.spawn("Page notification", nil) do
        everyone.each do |char|    
          title = Page.thread_title(thread_name, char)
          notification = "#{thread_name}|#{title}|#{Website.format_markdown_for_html(message)}"
          clients = Global.client_monitor.clients.select { |client| client.web_char_id == char.id }
          clients.each do |client|
            client.web_notify :new_page, notification
          end
        end
      end
        
      thread_name
    end
    
    def self.generate_thread_name(chars)
      chars.sort_by { |c| c.id.to_i }.map { |c| c.id }.join("_")
    end
    
    def self.chars_for_thread(thread_name)
      ids = thread_name.split('_')
      names = []
      ids.each do |id|
        char = Character[id]
        names << char ? char.name : nil
      end
      names
    end
    
    def self.thread_title(thread_name, enactor)
      chars = Page.chars_for_thread(thread_name)
      chars.select { |c| c != enactor }.map { |c| c.name }.join(", ")
    end
  end

end