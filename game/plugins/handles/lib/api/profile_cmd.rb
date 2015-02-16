module AresMUSH
  module Handles
    class ApiProfileCmdArgs
      attr_accessor :target, :viewer
      
      def initialize(target, viewer)
        self.target = target
        self.viewer = viewer
      end
      
      def to_s
        "#{target}||#{viewer}"
      end
      
      def validate
        return t('api.invalid_handle') if !Handles.handle_name_valid?(self.target)
        return nil
      end
     
      def self.create_from(command_args)
        target, viewer = command_args.split("||")
        ApiProfileCmdArgs.new(target, viewer)
      end
    end
  end
end