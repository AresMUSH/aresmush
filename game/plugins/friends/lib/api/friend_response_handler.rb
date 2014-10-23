module AresMUSH
  module Friends
    class FriendResponseHandler < ApiResponseHandler
      def handle   
        name = response.args_str
        if (response.command_name == "friend/add")
          client.char.handle_friends << name
          client.char.save!
          client.emit_success t('friends.friend_added', :name => name)
        else
          client.char.handle_friends.delete response.args_str
          client.char.save!
          client.emit_success t('friends.friend_removed', :name => name)
        end
      end
    end
  end
end