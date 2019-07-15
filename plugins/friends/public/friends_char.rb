module AresMUSH
  class Character
    collection :friendships, "AresMUSH::Friendship"

    before_delete :delete_friendships
    
    def delete_friendships
      self.friendships.each { |f| f.delete }
      self.friends_of.each { |f| f.delete }
    end
    
    def is_friend?(potential_friend)
      self.has_friended_char_or_handle?(potential_friend)
    end
    
    def friends
      friendships.map { |f| f.friend }
    end
    
    def friends_of
      Friendship.find(friend_id: self.id)
    end
    
    def has_friended_char_or_handle?(other_char)
      return true if friends.include?(other_char)
      
      this_handle = self.handle
      
      return false if !this_handle
      return false if !this_handle.friends
      return false if !other_char.handle
      
      return true if this_handle.friends.include?(other_char.handle.name)
      false
    end
  end  
end