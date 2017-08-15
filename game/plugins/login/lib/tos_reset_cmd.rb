module AresMUSH
  module Login
    class TosResetCmd
      include CommandHandler
      
      def check_can_reset
        return t('dispatcher.not_allowed')  if !Login.can_manage_login?(enactor)
        return nil
      end
      
      def handle
        Character.all.each { |c| c.update(terms_of_service_acknowledged: nil) }
        client.emit_success t('login.tos_reset')
      end
    end
  end
end
