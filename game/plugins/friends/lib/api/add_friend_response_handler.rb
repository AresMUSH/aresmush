module AresMUSH
  module Friends
    class AddFriendResponseHandler
      include ApiResponseHandler
      
      def self.commands
        ["friend/add"]
      end
      
      def self.available_on_master?
        false
      end
    
      def self.available_on_slave?
        true
      end
      
      def handle   
        name = response.args_str
        client.char.handle_friends << name
        client.char.save!
        client.emit_success t('friends.friend_added', :name => name)
      end
    end
  end
end