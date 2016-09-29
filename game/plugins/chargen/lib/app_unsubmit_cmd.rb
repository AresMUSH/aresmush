module AresMUSH
  module Chargen
    class AppUnsubmitCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
      
      def check_approval
        return t('chargen.you_are_already_approved') if enactor.is_approved
        return nil
      end
      
      def check_approval_job
        return t('chargen.you_have_not_submitted_app') if enactor.approval_job.nil?
        return nil
      end
      
      def handle
        Jobs::Api.change_job_status(client,
          enactor.approval_job,
          Global.read_config("chargen", "jobs", "app_hold_status"),
          t('chargen.app_job_unsubmitted'))
          
        enactor.chargen_locked = false
        enactor.save
          
        client.emit_success t('chargen.app_unsubmitted')
      end
    end
  end
end