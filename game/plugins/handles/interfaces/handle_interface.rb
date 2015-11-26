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
      if (Global.api_router.is_master?)
        client.emit_ooc t('handles.setting_preference_on_master')
      else
        if (client.char.handle)
          client.emit_ooc t('handles.setting_preference_on_linked_char')
        end
      end
    end
    
  end
end