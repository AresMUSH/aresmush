module AresMUSH
  module Friends
    class FriendsTemplate < ErbTemplateRenderer
            
      def initialize(enactor)
        @enactor = enactor
        super File.dirname(__FILE__) + "/friends.erb"        
      end
      
      def friendships
        @enactor.friendships.to_a.sort_by { |f| f.friend.name }
      end
      
      def unlinked_friendships
        @enactor.friendships.select { |f| !f.friend.handle }.sort_by { |f| f.friend.name }
      end

      def friend_note(friend)
        friendship = @enactor.friendships.select { |f| f.friend == friend }.first
        return friendship ? friendship.note : nil
      end
      
      def friend_name(friend)
        friend.name
      end
      
      def friend_loc(friend)
        Who.who_room_name(friend)
      end
      
      def handle_friends
        return [] if !@enactor.handle
        @enactor.handle.friends ? @enactor.handle.friends.sort : []
      end
      
      def visible_alts(handle_name)
        handle = Handle.find_one_by_name(handle_name)
        visible_alts = AresCentral.alts_of(handle)
        visible_alts.empty? ? nil : visible_alts
      end
      
      def friend_last_on(friend)
        if (Login.is_online?(friend))
          connected = t('friends.connected')
        else
          connected = OOCTime.local_long_timestr(@enactor, friend.last_on)
        end
      end
      
    end
  end
end
