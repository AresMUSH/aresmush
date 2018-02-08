module AresMUSH
  module Chargen
    class AppUnsubmitCmd
      include CommandHandler
      
      def check_approval
        return t('chargen.you_are_already_approved') if enactor.is_approved?
        return nil
      end
      
      def check_approval_job
        return t('chargen.you_have_not_submitted_app') if !enactor.approval_job
        return nil
      end
      
      def handle
        Chargen.unsubmit_app(enactor)
        client.emit_success t('chargen.app_unsubmitted')
      end
    end
  end
end