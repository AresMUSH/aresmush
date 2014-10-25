module AresMUSH
  module Friends
    class FriendResponseHandler
      include ApiResponseHandler
      
      def self.commands
        ["friend/remove"]
      end
      
      def self.available_on_master?
        false
      end
    
      def self.available_on_slave?
        true
      end
      
      def handle   
        name = response.args_str
        client.char.handle_friends.delete response.args_str
        client.char.save!
        client.emit_success t('friends.friend_removed', :name => name)
      end
    end
  end
end