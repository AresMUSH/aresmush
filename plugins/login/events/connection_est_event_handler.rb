module AresMUSH
  module Login
    class ConnectionEstablishedEventHandler    
      def on_event(event)
        client = event.client
        
        # Connect screen ansi
        connect_text = Global.config_reader.get_text('connect.txt')
        
        if (connect_text)
          client.emit connect_text
        else
          Global.logger.warn "Connect screen missing!"
        end

        # Ares welcome text
        client.emit_ooc t('client.welcome', :version => AresMUSH.version ? AresMUSH.version.chomp : "")
      end
    end
  end
end
    
    