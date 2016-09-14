module AresMUSH
  module Friends
    module Interface
      def self.is_friend?(char, potential_friend)
        char.has_friended_char_or_handle?(potential_friend)
      end
      
      def self.sync_handle_friends(char, friends)
        char.handle_friends = friends
      end
    end
  end
end