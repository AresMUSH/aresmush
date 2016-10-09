module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandRequiresLogin
            
      def crack!
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage::Api.can_manage_game?(enactor)
        return nil
      end
      
      def handle
        c = Character.find_one_by_name("Faraday")
        client.emit c.mail.count
        client.emit c.mail_prefs.inspect
        # Put whatever you need to do here.
        client.emit_success "Done!"
      end

    end
  end
end
