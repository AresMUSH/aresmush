module AresMUSH
  module Api
    class FriendCmdHandler < ApiCommandHandler
      attr_accessor :args
      
      def crack!
        self.args = ApiFriendArgs.create_from(cmd.args_str)
      end
      
      def validate
        return args.validate
      end
      
      def handle
        char = Character.where(handle: args.handle).first
        if (char.nil?)
          return cmd.create_error_response "Invalid handle."
        end
        
        # TODO: Check that the args.char_id is actually registered to this handle.
        
        if (cmd.command_name == "friend/add")
          error = Friend.add_friend(char, args.friend_name)
          if (error)
            return cmd.create_error_response error
          else
            return cmd.create_response(ApiResponse.status_ok, "args.friend_name")
          end
        else
          error = Friend.remove_friend(char, args.friend_name)
          if (error)
            return cmd.create_error_response error
          else
            return cmd.create_ok_response
          end
        end
      end
    end
  end
end