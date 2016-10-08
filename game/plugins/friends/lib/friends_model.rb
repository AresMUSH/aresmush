module AresMUSH
  class Character
    collection :friendships, "AresMUSH::Friendship"

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
  
  class Friendship < Ohm::Model
    include ObjectModel
    
    reference :character, "AresMUSH::Character"
    reference :friend, "AresMUSH::Character"
    
    attribute :note
  end
end