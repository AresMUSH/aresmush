module AresMUSH
  module AresCentral
    module Api      
      def self.warn_if_setting_linked_preference(client, enactor)
        if (enactor.handle)
          client.emit_ooc t('arescentral.setting_preference_on_linked_char')
        end
      end
    
      def self.alts(char)
        return [] if !char.handle
        Character.find_by_handle(char.handle)
      end
      
      def self.alts_of(handle)
        return [] if !handle
        Character.find_by_handle(handle)
      end
    end
  end
end