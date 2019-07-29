module AresMUSH
  module Login
    class CharConnectedEventHandler
      def on_event(event)
        client = event.client
        char = Character[event.char_id]
        
        first_login = !char.last_ip
        Login.update_site_info(client.ip_addr, client.hostname, char)

        Global.logger.info("Character Connected: #{char.name} #{char.last_ip} #{char.last_hostname}")
        if (first_login)
          Login.check_for_suspect(char)
        end
        
        char.room.emit_success t('login.announce_char_connected_here', :name => char.name)
        Global.client_monitor.logged_in.each do |other_client, other_char|
          if (Login.wants_announce(other_char, char) && char.room != other_char.room)
            other_client.emit_ooc t('login.announce_char_connected', :name => char.name)
          end
        end
        
        if (char.onconnect_commands)
          char.onconnect_commands.each_with_index do |cmd, i|
            Global.dispatcher.queue_timer(i + 1, "Login commands", client) do 
              Global.dispatcher.queue_command(client, Command.new(cmd))
            end
          end
          notice_delay = char.onconnect_commands.count * 2
        else
          notice_delay = 2
        end
        
        Global.dispatcher.queue_timer(notice_delay, "Login notices", client) do 
          template = NoticesSummaryTemplate.new(char)
          client.emit template.render
        end
      end
    end
  end
end
