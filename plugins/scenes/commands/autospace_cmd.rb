module AresMUSH
  module Scenes
    class AutospaceCmd
      include CommandHandler
      
      attr_accessor :option
      
      def parse_args
        self.option = trim_arg(cmd.args)
      end

      def handle
        
        if (!self.option)
          enactor.update(pose_autospace: nil)
          message = t('scenes.autospace_cleared')
        else
          enactor.update(pose_autospace: self.option)
          formatted = Scenes.format_autospace(enactor, self.option)
          message = t('scenes.autospace_set', :option => formatted)
        end
        
        client.emit_success message
        AresCentral.warn_if_setting_linked_preference(client, enactor)
      end
    end
  end
end
