module AresMUSH
  module Chargen
    class AppSubmitCmd
      include CommandHandler
      
      def check_approval
        return t('chargen.you_are_already_approved') if enactor.is_approved?
        return nil
      end
      
      def handle
        if (cmd.switch_is?("confirm"))
          client.emit_success Chargen.submit_app(enactor)
          client.emit_ooc t('chargen.approval_reminder')
        else
          client.emit_ooc t('chargen.app_confirm')
        end
      end
    end
  end
end