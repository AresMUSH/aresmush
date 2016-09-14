module AresMUSH
  module Handles
    module Interface      
      def self.warn_if_setting_linked_preference(client)
        if (client.char.handle)
          client.emit_ooc t('handles.setting_preference_on_linked_char')
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
      
      def self.ooc_name(char)
        char.ooc_name
      end
    end
  end
end