module AresMUSH
  module Handles
    class CharConnectedEventHandler
      def on_event(event)
        char = event.char
        return if !char.handle
        
         AresMUSH.with_error_handling(event.client, "Syncing handle with AresCentral.") do
          connector = AresCentral::AresConnector.new
        
          Global.logger.info "Updating handle for #{char.handle.handle_id}"
          response = connector.sync_handle(char.handle.handle_id, char.name, char.id)

          if (response.is_success?)
            if (response.data["linked"])
              char.autospace = response.data["autospace"]
              char.timezone = response.data["timezone"]
              char.handle.update(friends: response.data["friends"])
              char.save
              event.client.emit_success t('handles.handle_synced')              
            else
              char.handle.delete
              event.client.emit_success t('handles.handle_no_longer_linked')
            end
          else
            raise "Response failed: #{response}"
          end
        end   
      end
    end
  end
end