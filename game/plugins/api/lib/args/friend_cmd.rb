module AresMUSH
  module Api
    class ApiFriendCmdArgs
      attr_accessor :char_id, :handle_name, :friend_name
      
      def initialize(char_id, handle_name, friend_name)
        self.char_id = char_id
        self.handle_name = handle_name
        self.friend_name = friend_name
      end
      
      def to_s
        "#{char_id}||#{handle_name}||#{friend_name}"
      end
      
      def validate
        return "Missing character id." if self.char_id.blank?
        return "Invalid handle name.  Make sure it starts with @." if !Handles.handle_name_valid?(self.handle_name)
        return "Missing friend name." if self.friend_name.blank?
        return nil
      end
     
      def self.create_from(command_args)
        char_id, handle_name, friend_name = command_args.split("||")
        ApiFriendCmdArgs.new(char_id, handle_name, friend_name)
      end
    end
  end
end