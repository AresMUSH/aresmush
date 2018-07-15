# Test
module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler
           
      def check_can_tinker
        return t('dispatcher.not_allowed') if !enactor.is_coder?
        return nil
      end
      
      def handle
        # Test
        client.emit_success t('global.done')
      end

    end
  end
end
