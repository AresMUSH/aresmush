module AresMUSH
  module Api
    class FriendResponseHandler < ApiResponseHandler
      def handle   
        if (response.command_name == "friend/add")
          client.char.handle_friends << response.args_str
          client.char.save!
          client.emit_success "Friend added."
        else
          client.char.handle_friends.delete response.args_str
          client.char.save!
          client.emit_success "Friend removed."
        end
      end
    end
  end
end