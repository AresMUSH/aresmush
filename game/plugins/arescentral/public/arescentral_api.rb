module AresMUSH
  class Character
    def alts
      AresCentral.alts(self)
    end
  end
  
  module AresCentral
    
    # Emits a standard warning message to a client whenever they change a 
    # preference that will be overridden by their AresCentral preferences.
    def self.warn_if_setting_linked_preference(client, enactor)
      if (enactor.handle)
        client.emit_ooc t('arescentral.setting_preference_on_linked_char')
      end
    end
    
    def self.alts(char)
      return [] if !char.handle
      Character.find_by_handle(char.handle).select { |c| c }
    end
      
    def self.alts_of(handle)
      return [] if !handle
      Character.find_by_handle(handle).select { |c| c }
    end
    
    def self.is_alt?(char1, char2)
      return false if !char1.handle
      return false if !char2.handle
      char1.handle.id == char2.handle.id
    end
  end
end