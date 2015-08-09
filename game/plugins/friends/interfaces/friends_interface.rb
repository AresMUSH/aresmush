module AresMUSH
  module Friends
    def self.add_friend(char, friend_name)
      result = ClassTargetFinder.find(friend_name, Character, nil)
      if (!result.found?)
        return result.error
      end
      friend = result.target

      if (char.friends.include?(friend))
        return t('friends.already_friend', :name => friend_name)
      end
      friendship = Friendship.new(:character => char, :friend => friend)
      friendship.save!
      return nil
    end
    
    def self.remove_friend(char, friend_name)
      result = Friends.find_friendship(char, friend_name)
      
      if (result[:friendship].nil?)
        return result[:error]
      end
      
      result[:friendship].destroy
      return nil
    end
    
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