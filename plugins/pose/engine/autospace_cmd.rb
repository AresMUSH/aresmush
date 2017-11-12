module AresMUSH
  module Pose
    class AutospaceCmd
      include CommandHandler
      
      attr_accessor :option
      
      def parse_args
        self.option = trim_arg(cmd.args)
      end

      def handle
        
        if (!self.option)
          enactor.update(pose_autospace: nil)
          message = t('pose.autospace_cleared')
        else
          enactor.update(pose_autospace: self.option)
          message = t('pose.autospace_set', :option => self.option)
        end
        
        client.emit_success message
        AresCentral.warn_if_setting_linked_preference(client, enactor)
      end
    end
  end
end
