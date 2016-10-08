module AresMUSH
  module Friends
    def self.find_friendship(char, friend_name)
      result = ClassTargetFinder.find(friend_name, Character, char)
      if (!result.found?)
        return { :friendship => nil, :error => result.error }
      end
      
      friend = result.target
      
      friendship = Friendship.find(character_id: char.id).combine(friend_id: friend.id).first
      if (!friendship)
        return { :friendship => nil, :error => t('friends.not_friend', :name => friend_name) }
      end
      
      { :friendship => friendship, :error => nil } 
    end
  end
end