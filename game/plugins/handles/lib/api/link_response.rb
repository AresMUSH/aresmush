module AresMUSH
  module Handles
    class ApiLinkResponseArgs
      attr_accessor :handle_name
      
      def initialize(handle_name)
        self.handle_name = handle_name
      end
      
      def to_s
        "#{handle_name}"
      end
      
      def validate
        return t('api.invalid_handle') if !Handles.handle_name_valid?(self.handle_name)
        return nil
      end
     
      def self.create_from(response_args)
        handle_name, garbage = response_args.split("||")
        ApiLinkResponseArgs.new(handle_name)
      end
    end
  end
end