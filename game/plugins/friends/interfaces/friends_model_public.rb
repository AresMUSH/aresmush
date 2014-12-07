module AresMUSH
  class Character
    field :handle_friends, :type => Array, :default => []
    
    def has_friended_char_or_handle?(other_char)
       has_friended_char?(other_char) || has_friended_handle?(other_char)
    end
    
    def has_friended_char?(other_char)
      friends.include?(other_char)
    end
    
    def has_friended_handle?(other_char)
      handle_friends.include?(other_char.handle)
    end
    
    def friends
      friendships.map { |f| f.friend }
    end
  end  
end