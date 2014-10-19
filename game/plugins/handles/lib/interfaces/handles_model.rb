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
    field :temp_link_codes, :type => Hash, :default => {}
    field :linked_characters, :type => Hash, :default => {}
        
    def handle_visible_to?(other_char)
      return true if handle_privacy == Handles.privacy_public
      return false if handle_privacy == Handles.privacy_private
      has_friended_char_or_handle?(other_char)
    end
    
    def ooc_name
      if (handle_only)
        return handle
      end
      
      aliases = []
      
      if (handle_privacy == Handles.privacy_public)
        name_part = handle
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
    
    def self.find_by_handle(name)
      Character.where(handle: name).all
    end
    
  end
end