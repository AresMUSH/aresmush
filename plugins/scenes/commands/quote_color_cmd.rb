module AresMUSH
  module Scenes
    class QuoteColorCmd
      include CommandHandler
      
      attr_accessor :option
      
      def parse_args
        self.option = trim_arg(cmd.args)
      end

      def handle
        if (!self.option)
          enactor.update(pose_quote_color: nil)
          message = t('scenes.quote_color_cleared')
        else
          enactor.update(pose_quote_color: self.option)
          message = t('scenes.quote_color_set', :option => self.option)
        end
        
        client.emit_success message
        AresCentral.warn_if_setting_linked_preference(client, enactor)
      end
    end
  end
end
