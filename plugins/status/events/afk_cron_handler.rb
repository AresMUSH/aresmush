module AresMUSH
  module Status    
    class AfkCronHandler
      
      def on_event(event)
        return if !Cron.is_cron_match?(Global.read_config('status', 'afk_cron'), event.time)
        
        minutes_before_idle_disconnect = "#{Global.read_config('status', 'minutes_before_idle_disconnect')}".to_i
        return if minutes_before_idle_disconnect == 0
        
        Global.client_monitor.logged_in_clients.each do |client|
          if (client.idle_secs > minutes_before_idle_disconnect * 60)
            char = client.char
            if (char && char.has_permission?("can_idle_indefinitely"))
              next
            end
            client.emit_ooc t('status.afk_disconnect')
            client.disconnect
          end
        end
      end
    end    
  end
end