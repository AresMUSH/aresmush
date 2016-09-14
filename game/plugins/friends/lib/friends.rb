module AresMUSH
  module Friends
    def self.find_friendship(char, friend_name)
      result = ClassTargetFinder.find(friend_name, Character, nil)
      if (!result.found?)
        return { :friendship => nil, :error => result.error }
      end
      
      friend = result.target
      
      friendship = Friendship.where(:character => char, :friend => friend).first
      if (friendship.nil?)
        return { :friendship => nil, :error => t('friends.not_friend', :name => friend_name) }
      end
      
      { :friendship => friendship, :error => nil } 
    end
  end
end