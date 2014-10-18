module AresMUSH
  module Friends
    def self.add_friend(char, friend_name)
      result = ClassTargetFinder.find(friend_name, Character, client)
      if (!result.found)
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
      result = ClassTargetFinder.find(friend_name, Character, client)
      if (!result.found)
        return result.error
      end
      
      friend = result.target
      
      friendship = Friendship.where(:character => char, :friend => friend)
      if (friendship.nil?)
        return t('friends.not_friend', :name => friend_name)
      end
      
      friendship.destroy
      return nil
    end
  end
end