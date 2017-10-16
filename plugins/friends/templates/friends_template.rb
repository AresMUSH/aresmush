module AresMUSH
  module Friends
    # Template for an exit.
    class FriendsTemplate < ErbTemplateRenderer
            
      def initialize(enactor)
        @enactor = enactor
        super File.dirname(__FILE__) + "/friends.erb"        
      end
      
      def friendships
        @enactor.friendships.to_a.sort_by { |f| f.friend.name }
      end
      
      def friend_name(friendship)
        friendship.friend.name
      end
      
      def handle_friends
        return [] if !@enactor.handle
        @enactor.handle.friends ? @enactor.handle.friends.sort : []
      end
      
      def visible_alts(handle_name)
        handle = Handle.find_one_by_name(handle_name)
        visible_alts = AresCentral.alts_of(handle)
        visible_alts.empty? ? nil : visible_alts.map { |a| a.name }.join(" ")
      end
      
      def friend_last_on(friendship)
        char = friendship.friend
        if (char.client)
          connected = t('friends.connected')
        else
          connected = OOCTime.local_long_timestr(@enactor, char.last_on)
        end
      end
      
    end
  end
end
