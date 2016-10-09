module AresMUSH
  module Pose
    class AutospaceCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandRequiresLogin
      
      attr_accessor :option
      
      def crack!
        self.option = trim_input(cmd.args)
      end

      def handle
        prefs = Pose.get_or_create_pose_prefs(enactor)
        
        if (!self.option)
          prefs.update(autospace: nil)
          message = t('pose.autospace_cleared')
        else
          prefs.update(autospace: self.option)
          message = t('pose.autospace_set', :option => self.option)
        end
        
        client.emit_success message
        Handles::Api.warn_if_setting_linked_preference(client, enactor)
      end
    end
  end
end
