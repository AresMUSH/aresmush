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
        if (self.option.nil?)
          enactor.autospace = nil
          message = t('pose.autospace_cleared')
        else
          enactor.autospace = self.option
          message = t('pose.autospace_set', :option => self.option)
        end
        
        enactor.save!
        client.emit_success message
        
        Handles::Api.warn_if_setting_linked_preference(client)
      end
    end
  end
end
