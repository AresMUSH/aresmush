module AresMUSH
  module Handles
    def self.privacy_public
      "public"
    end
    
    def self.privacy_admin
      "admin-only"
    end
    
    def self.privacy_friends
      "friends-only"
    end
    
    def self.handle_name_valid?(name)
      return false if name.blank?
      name.start_with?("@")
    end
    
    def self.find_visible_alts(handle, viewer)
      return [] if handle.blank?
      Character.find_by_handle(handle).select { |c| c.handle_visible_to?(viewer) }
    end
    
    def self.get_visible_alts_name_list(model, actor)
      list = Handles.find_visible_alts(model.handle, actor)
      if (list.empty?)
        t('handles.no_alts')
      else
        list.map { |l| l.name }.join(", ")
      end
    end
    
    def self.warn_if_setting_linked_preference(client)
      if (client.char.handle)
        client.emit_ooc t('handles.setting_preference_on_linked_char')
      end
    end
    
    def self.sync_char_with_master(client)
      # TODO!!
      return
      char = client.char
      return if char.handle.blank?
      
      args = ApiSyncCmdArgs.new(char.api_character_id, 
        char.handle, 
        char.name, 
        char.handle_privacy)
      cmd = ApiCommand.new("sync", args.to_s)
      Global.api_router.send_command(ServerInfo.arescentral_game_id, client, cmd)
      Global.logger.info "Login update received for #{client.name}."
      
      char = client.char
      
      if (char.handle_friends != self.args.friends.split(" ") ||
          char.autospace != self.args.autospace ||
          char.timezone != self.args.timezone)
        return
      end
            
      char.handle_friends = self.args.friends.split(" ")
      if (char.handle_sync)
        char.autospace = self.args.autospace
        char.timezone = self.args.timezone
        client.emit_ooc t('handles.handle_synced')
      end
      char.save!
    end
    
  end
end