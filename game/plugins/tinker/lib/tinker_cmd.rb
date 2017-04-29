require 'aws-sdk'


module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler
            
      def parse_args
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.can_manage_game?
        return nil
      end
      
      def handle
        enactor.update(terms_of_service_acknowledged: nil)
        client.emit_success "Done!"
      end

    end
  end
end
