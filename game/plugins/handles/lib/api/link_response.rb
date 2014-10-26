module AresMUSH
  module Handles
    class ApiLinkResponseArgs
      attr_accessor :handle_name, :handle_friends
      
      def initialize(handle_name, handle_friends)
        self.handle_name = handle_name
        self.handle_friends = handle_friends
      end
      
      def to_s
        "#{handle_name}||#{handle_friends}"
      end
      
      def validate
        return t('api.invalid_handle') if !Handles.handle_name_valid?(self.handle_name)
        return nil
      end
     
      def self.create_from(response_args)
        handle_name, handle_friends = response_args.split("||")
        ApiLinkResponseArgs.new(handle_name, handle_friends)
      end
    end
  end
end