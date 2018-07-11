module AresMUSH
  module AresCentral
    class RegisterGameCmdHandler
      include CommandHandler
      
      def check_is_allowed
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end
      
      def handle
        if (AresCentral.is_registered?)
          client.emit_failure t('arescentral.game_already_registered')
          return
        end
        AresCentral.register_game
        client.emit_success t('arescentral.game_registered')
      end      
    end

  end
end
