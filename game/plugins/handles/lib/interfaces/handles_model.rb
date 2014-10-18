module AresMUSH
  module Handles
    def self.privacy_public
      "public"
    end
    
    def self.privacy_private
      "private"
    end
    
    def self.privacy_friends
      "friends"
    end
  end
  
  class Character
    field :handle, :type => String
    field :handle_privacy, :type => String, :default => Handles.privacy_friends
    field :handle_only, :type => Boolean
    
    def api_character_id
      data = "#{Game.master.api_game_id}#{id}"
      Base64.strict_encode64(data).encode('ASCII-8BIT')
    end
    
    def handle_name
      handle.nil? ? nil : "@#{handle}"
    end
    
    def handle_visible_to?(other_char)
      return true if handle_privacy == Handles.privacy_public
      return false if handle_privacy == Handles.privacy_private
      is_friends_with?(other_char)
    end
    
    def ooc_name
      if (handle_only)
        return handle_name
      end
      
      aliases = []
      
      if (handle_privacy == Handles.privacy_public)
        name_part = handle_name
        aliases << name
      else
        name_part = name
      end
      
      if (self.alias)
        aliases << self.alias
      end
      
      if (aliases.count > 0)
        "#{name_part} (#{aliases.join(", ")})"
      else
        name_part
      end
    end
  end
end