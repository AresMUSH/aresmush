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
  end
  
  class Character
    field :handle, :type => String
    field :handle_profile, :type => String
    field :handle_privacy, :type => String, :default => Handles.privacy_friends
    field :handle_main, :type => Boolean
    field :temp_link_codes, :type => Hash, :default => {}
    field :linked_characters, :type => Hash, :default => {}

    def handle_visible_to?(other_char)
      return true if handle_privacy == Handles.privacy_public
      return false if handle_privacy == Handles.privacy_admin
      has_friended_char_or_handle?(other_char)
    end
    
    def public_handle?
      handle_privacy == Handles.privacy_public
    end
    
    def ooc_name
      aliases = []
      
      if (public_handle?)
        name_part = handle
        if (handle != "@#{name}")
          aliases << name
        end
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
      return [] if name.nil?
      Character.all.select { |c| (c.handle.nil? ? "" : c.handle.downcase) == name.downcase }
    end
    
  end
end