module AresMUSH
  module Pose
    class QuoteColorCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandRequiresLogin
      
      attr_accessor :option
      
      def crack!
        self.option = trim_input(cmd.args)
      end

      def handle
        if (!self.option)
          enactor.update(pose_quote_color: nil)
          message = t('pose.quote_color_cleared')
        else
          enactor.update(pose_quote_color: self.option)
          message = t('pose.quote_color_set', :option => self.option)
        end
        
        client.emit_success message
        Handles::Api.warn_if_setting_linked_preference(client, enactor)
      end
    end
  end
end
