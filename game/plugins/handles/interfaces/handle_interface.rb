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
    
    def self.warn_if_setting_linked_preference(client)
      if (Global.api_router.is_master?)
        client.emit_ooc t('handles.setting_preference_on_master')
      else
        if (client.char.handle)
          client.emit_ooc t('handles.setting_preference_on_linked_char')
        end
      end
    end
    
    def self.build_profile_text(profile_char, asking_char)
      if (Global.api_router.is_master?)
        text = "-~- %xh%xg@#{profile_char.name}%xn -~-".center(78)
        text << "%r%l2%r"
        text << "%xh#{t('handles.profile_title')}%xn"
        text << "%r"
        text << (profile_char.handle_profile.nil? ? t('handles.no_profile_set') : profile_char.handle_profile)
        text << "%r%r%l2%r"
        text << t('handles.profile_char_list_title')
        text << "%r%l2"
        profile_char.linked_characters.values.each do |c| 
          next if c['privacy'] == Handles.privacy_admin
          next if c['privacy'] == Handles.privacy_friends && !profile_char.friends.include?(asking_char)
          
          game = ServerInfo.find_by_dest_id(c['game_id'])
          game_name = game.nil? ? "Unknown" : game.name
          name = "#{c['name']}@#{game_name}"
          last_online = "#{c['last_login']}"   
          text << "%R#{name.ljust(40)} #{last_online}"
        end
        
        BorderedDisplay.text text
      else
        return t('api.use_command_on_central')
      end
    end
  end
end