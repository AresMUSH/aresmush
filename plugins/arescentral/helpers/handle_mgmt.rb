module AresMUSH
  module AresCentral
    def self.sync_handle(char)
      return if !AresCentral.is_registered?
      return if !char.handle
      
      AresMUSH.with_error_handling(nil, "Syncing handle with AresCentral.") do
        connector = AresCentral::AresConnector.new
      
        Global.logger.info "Updating handle for #{char.handle.handle_id}"
        
        begin
          response = connector.sync_handle(char.handle.handle_id, char.name, char.id)
          
          # Update character reference since it may have been awhile since the response came in.
          char = Character[char.id]

          if (response.is_success?)
            if (response.data["linked"])
              char.update(pose_quote_color: response.data["quote_color"])
              char.update(page_autospace: response.data["page_autospace"])
              char.update(page_color: response.data["page_color"])
              char.update(pose_autospace: response.data["autospace"])
              char.update(timezone: response.data["timezone"])
              char.update(ascii_mode_enabled: response.data["ascii_only"])
              char.update(screen_reader: response.data["screen_reader"])
              char.handle.update(friends: response.data["friends"])
              char.handle.update(profile: response.data["profile"])
              return nil
            else
              char.handle.delete
              return t('arescentral.handle_no_longer_linked')
            end
          else
            raise "Response failed: #{response}"
          end
        rescue Exception => ex
          Global.logger.warn "Trouble syncing handle: #{ex}"
          return t('arescentral.trouble_syncing_handle')
        end
      end  
    end
    
    def self.link_handle(char, handle_name, link_code)
      if (!AresCentral.is_registered?)
        return t('arescentral.game_not_registered')
      end
      
      # Strip off the @ a the front if they made one.
      handle_name = handle_name.sub(/^@/, '')
      
      AresMUSH.with_error_handling(nil, "Linking char to AresCentral handle.") do
        Global.logger.info "Linking #{char.name} to #{handle_name}."
      
        connector = AresCentral::AresConnector.new
        response = connector.link_char(handle_name, link_code, char.name, char.id.to_s)
      
        if (response.is_success?)
          handle = Handle.create(name: response.data["handle_name"], 
          handle_id: response.data["handle_id"],
          character: char)
          char.update(handle: handle)
          
          Achievements.award_achievement(char, 'handle_linked')
          return nil
        else
          return t('arescentral.link_failed', :error => response.error_str)
        end  
      end
    end
    
    def self.unlink_handle(char)
      return if !AresCentral.is_registered?
      return if !char.handle
      char.handle.delete
      
      AresMUSH.with_error_handling(nil, "Unlinking handle with AresCentral.") do
        connector = AresCentral::AresConnector.new
      
        Global.logger.info "Removing handle link for #{char.handle.handle_id}"
        
        response = connector.unlink_handle(char.handle.handle_id, char.name, char.id)
          
        if (!response.is_success?)
          Global.logger.error "Handle unlink failed: #{response.error_str}"
        end
      end
    end  
  end
end