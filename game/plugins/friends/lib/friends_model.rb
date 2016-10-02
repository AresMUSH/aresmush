module AresMUSH
  class Character
    collection :friendships, "AresMUSH::Friendship"
    set :handle_friends, "AresMUSH::SimpleData"

    def friends
      friendships.map { |f| f.friend }
    end
    
    def friends_of
      Friendship.find(friend_id: self.id)
    end
    
    def has_friended_char_or_handle?(other_char)
       friends.include?(other_char) || handle_friends.include?(other_char.handle)
    end
  end  
  
  class Friendship < Ohm::Model
    include ObjectModel
    
    reference :character, "AresMUSH::Character"
    reference :friend, "AresMUSH::Character"
    
    attribute :note
  end
end