module AresMUSH
  module AresCentral
  
    class CharConnectedEventHandler
      def on_event(event)
        char = Character[event.char_id]
        return if !char.handle
        return if !AresCentral.is_registered?
        
         AresMUSH.with_error_handling(event.client, "Syncing handle with AresCentral.") do
          connector = AresCentral::AresConnector.new
        
          Global.logger.info "Updating handle for #{char.handle.handle_id}"
          
          begin
            response = connector.sync_handle(char.handle.handle_id, char.name, char.id)
            
            # Update character reference since it may have been awhile since the response came in.
            char = Character[event.char_id]

            if (response.is_success?)
              if (response.data["linked"])
                char.update(pose_quote_color: response.data["quote_color"])
                char.update(page_autospace: response.data["page_autospace"])
                char.update(page_color: response.data["page_color"])
                char.update(pose_autospace: response.data["autospace"])
                char.update(timezone: response.data["timezone"])
                char.update(ascii_mode_enabled: response.data["ascii_only"])
                char.handle.update(friends: response.data["friends"])
                event.client.emit_success t('arescentral.handle_synced')              
              else
                char.handle.delete
                event.client.emit_failure t('arescentral.handle_no_longer_linked')
              end
            else
              raise "Response failed: #{response}"
            end
          rescue Exception => ex
            event.client.emit_failure t('arescentral.trouble_syncing_handle')
            Global.logger.warn "Trouble syncing handle: #{ex}"
          end
        end   
      end
    end
    
  end
end