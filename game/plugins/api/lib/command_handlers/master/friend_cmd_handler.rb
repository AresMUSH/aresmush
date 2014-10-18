module AresMUSH
  module Api
    class FriendCmdHandler < ApiCommandHandler
      attr_accessor :args
      
      def crack!
        self.args = ApiFriendCmdArgs.create_from(cmd.args_str)
      end
      
      def validate
        return args.validate
      end
      
      def handle
        char_name = args.handle.after("@")
        friend_name = args.friend_name.after("@")
        
        Global.logger.debug "Adding #{friend_name} as a friend for #{char_name}."
        char = Character.where(name: char_name).first
        if (char.nil?)
          return cmd.create_error_response "Invalid handle."
        end
        
        # TODO: Check that the args.char_id is actually registered to this handle.

        if (cmd.command_name == "friend/add")
          error = Friends.add_friend(char, friend_name)
          if (error)
            return cmd.create_error_response error
          else
            return cmd.create_response(ApiResponse.ok_status, args.friend_name)
          end
        else
          error = Friends.remove_friend(char, friend_name)
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