module AresMUSH
  module Friends
    class RemoveFriendCmdHandler
      include ApiCommandHandler
      attr_accessor :args
      
      def self.commands
        ["friend/remove"]
      end
      
      def self.available_on_master?
        true
      end
      
      def self.available_on_slave?
        false
      end

      def crack!
        self.args = ApiFriendCmdArgs.create_from(cmd.args_str)
      end
      
      def validate
        return args.validate
      end
      
      def handle
        char_name = args.handle_name.after("@")
        friend_name = args.friend_name.after("@")
        
        Global.logger.debug "Adding #{friend_name} as a friend for #{char_name}."
        char = Character.find_by_name(char_name)
        if (char.nil?)
          return cmd.create_error_response t('api.invalid_handle')
        end
        
        if (!char.linked_characters.has_key?(args.char_id))
          return cmd.create_error_response t('api.character_not_linked')
        end
        
        error = Friends.remove_friend(char, friend_name)
        if (error)
          return cmd.create_error_response error
        else
          return cmd.create_response(ApiResponse.ok_status, args.friend_name)
        end
      end
    end
  end
end