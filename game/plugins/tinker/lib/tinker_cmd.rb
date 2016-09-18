module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandRequiresLogin
            
      def want_command?(client, cmd)
        cmd.root_is?("tinker")
      end
      
      def crack!
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(client.char)
        return nil
      end
      
      def handle
        # Put whatever you need to do here.
        client.emit_success "Done2!"
      end

    end
  end
end
