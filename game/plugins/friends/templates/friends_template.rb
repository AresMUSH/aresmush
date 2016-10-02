module AresMUSH
  module Friends
    # Template for an exit.
    class FriendsTemplate < ErbTemplateRenderer
      include TemplateFormatters
            
      def initialize(enactor)
        @enactor = enactor
        super File.dirname(__FILE__) + "/friends.erb"        
      end
      
      def friendships
        @enactor.friendships.sort_by { |f| f.friend.name }
      end
      
      def friend_name(friendship)
        friendship.friend.name
      end
      
      def handle_friends
        @enactor.handle_friends.sort
      end
      
      def visible_alts(handle)
        visible_alts = Handles::Api.alts_of(handle)
        visible_alts.empty? ? nil : visible_alts.map { |a| a.name }.join(" ")
      end
      
      def friend_last_on(friendship)
        char = friendship.friend
        if (char.client)
          connected = t('friends.connected')
        else
          connected = OOCTime::Api.local_long_timestr(@enactor, Login::Api.last_on(char))
        end
      end
      
    end
  end
end
