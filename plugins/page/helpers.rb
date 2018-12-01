module AresMUSH
  module Page
    
    def self.format_page_indicator(char)
      t('page.page_indicator',
      :start_marker => Global.read_config("page", "page_start_marker") || "<",
      :end_marker => Global.read_config("page", "page_end_marker") || "<",
      :color => Page.page_color(char) )
    end
    
    def self.format_recipient_indicator(names)
      return t('page.recipient_indicator', :recipients => names.join(" "))
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
      if (other_char.is_afk)
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
    
  end

end