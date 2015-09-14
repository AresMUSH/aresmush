module AresMUSH
  class Character
    field :handle, :type => String
    field :handle_privacy, :type => String, :default => Handles.privacy_friends
    field :handle_sync, :type => Boolean
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
      if (public_handle? && !Global.api_router.is_master?)
        display_name = "#{self.name} (#{self.handle})"
      else
        display_name = self.name
      end
      
      return display_name

      # TODO - Delete this if it's going to stay this way.
      #if (public_handle?)
      #  name_part = handle
      #  if (handle != "@#{name}")
      #    aliases << name
      #  end
      #else
      #  name_part = name
      #end
      # 
      #if (self.alias)
      #  aliases << self.alias
      #end
      #
      #if (aliases.count > 0)
      #  "#{name_part} (#{aliases.join(", ")})"
      #else
      #  name_part
      #end
    end
    
    def self.find_by_handle(name)
      return [] if name.nil?
      Character.all.select { |c| (c.handle.nil? ? "" : c.handle.downcase) == name.downcase }
    end
  end
end