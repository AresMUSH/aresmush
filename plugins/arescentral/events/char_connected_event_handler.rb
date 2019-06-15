module AresMUSH
  module AresCentral
  
    class CharConnectedEventHandler
      def on_event(event)
        char = Character[event.char_id]
        return if !char.handle
        
        error = AresCentral.sync_handle(char) 
        if (error)
          event.client.emit_failure error
        else
          event.client.emit_success t('arescentral.handle_synced')
        end
      end
    end
    
  end
end