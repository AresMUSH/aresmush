module AresMUSH
  module Friends
    class ApiFriendCmdArgs
      attr_accessor :char_id, :handle_name, :friend_name
      
      def initialize(char_id, handle_name, friend_name)
        self.char_id = char_id
        self.handle_name = handle_name
        self.friend_name = friend_name
      end
      
      def to_s
        "#{handle_name}||#{char_id}||#{friend_name}"
      end
      
      def validate
        return t('api.invalid_char_id') if self.char_id.blank?
        return t('api.invalid_handle') if !Handles.handle_name_valid?(self.handle_name)
        return t('friends.invalid_friend_name') if self.friend_name.blank?
        return nil
      end
     
      def self.create_from(command_args)
        handle_name, char_id, friend_name = command_args.split("||")
        ApiFriendCmdArgs.new(char_id, handle_name, friend_name)
      end
    end
  end
end