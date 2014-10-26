module AresMUSH
  module Handles
    class ProfileCmdHandler
      include ApiCommandHandler
      attr_accessor :args
      
      def self.commands
        ["profile"]
      end
      
      def self.available_on_master?
        true
      end
      
      def self.available_on_slave?
        false
      end
      
      def crack!
        self.args = ApiProfileCmdArgs.create_from(cmd.args_str)
      end
      
      def validate
        return args.validate
      end
      
      def handle
        Global.logger.debug "Viewing profile for #{args.target} by #{args.viewer}."
        
        target_name = args.target.after("@")
        target = Character.find_by_name(target_name)
        if (char.nil?)
          return cmd.create_error_response t('api.invalid_handle')
        end
        
        viewer_name = args.viewer.after("@")
        viewer = Character.find_by_name(viewer_name)
        if (char.nil?)
          return cmd.create_error_response t('api.invalid_handle')
        end
        
        profile_text = Handles.build_profile_text(target, viewer)
        return cmd.create_response(ApiResponse.ok_status, profile_text)
      end
    end
  end
end