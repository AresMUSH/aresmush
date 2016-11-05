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
        @enactor.friendships.to_a.sort_by { |f| f.friend.name }
      end
      
      def friend_name(friendship)
        friendship.friend.name
      end
      
      def handle_friends
        return [] if !@enactor.handle
        @enactor.handle.friends ? @enactor.handle.friends.sort_by(:name, :order => "ALPHA") : []
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
          connected = OOCTime::Api.local_long_timestr(@enactor, char.last_on)
        end
      end
      
    end
  end
end
