module AresMUSH
  module AresCentral
  
    class CharConnectedEventHandler
      def on_event(event)
        char = Character[event.char_id]
        client = event.client
        return if !char.handle
        
        error = AresCentral.sync_handle(char) 
        
        return if !client
        if (error)
          client.emit_failure error
        else
          client.emit_success t('arescentral.handle_synced')
        end
      end
    end
    
  end
end