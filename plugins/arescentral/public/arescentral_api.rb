module AresMUSH
  module AresCentral
    
    # Emits a standard warning message to a client whenever they change a 
    # preference that will be overridden by their AresCentral preferences.
    def self.warn_if_setting_linked_preference(client, enactor)
      if (enactor.handle)
        client.emit_ooc t('arescentral.setting_preference_on_linked_char')
      end
    end
    
    # Note: This finds ALL characters registered to the same handle, so the character 
    # you're asking about is included in the resulting list.
    def self.alts(char)
      return [char] if !char.handle
      Character.find_by_handle(char.handle).select { |c| c }
    end
      
    def self.alts_of(handle)
      return [] if !handle
      Character.find_by_handle(handle).select { |c| c }
    end
    
    def self.is_alt?(char1, char2)
      return false if !char1 || !char2
      return true if char1.name == char2.name
      return false if !char1.handle
      return false if !char2.handle
      char1.handle.name == char2.handle.name
    end
    
    def self.is_registered?
      !!Game.master.api_game_id
    end
    
    # Includes both handle linking and player tag linking.
    def self.are_chars_linked?(char1, char2)
      return true if AresCentral.is_alt?(char1, char2)
      tag1 = Profile.get_player_tag(char1)
      tag2 = Profile.get_player_tag(char2)
      return false if !tag1
      return false if !tag2
      return tag1 == tag2
    end
    
    def self.play_screen_alts(char)
      return false if !char
      char.unified_play_screen ? AresCentral.alts(char) : [char]
    end
    
    def self.is_play_screen_alt?(char1, char2)
      return false if !char1
      return false if !char2
      AresCentral.play_screen_alts(char1).include?(char2)
    end
    
  end
end