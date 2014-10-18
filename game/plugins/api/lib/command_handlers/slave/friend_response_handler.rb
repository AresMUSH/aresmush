module AresMUSH
  module Api
    class FriendResponseHandler < ApiResponseHandler
      def handle   
        client.char.handle_friends << response.args_str
        client.char.save!
        client.emit_success "Friend added."
      end
    end
  end
end