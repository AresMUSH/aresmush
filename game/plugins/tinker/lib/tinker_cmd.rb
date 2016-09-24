module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandRequiresLogin
            
      def crack!
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage::Api.can_manage_game?(client.char)
        return nil
      end
      
      def handle
        # Put whatever you need to do here.
        client.emit_success "Done!"
      end

    end
  end
end
