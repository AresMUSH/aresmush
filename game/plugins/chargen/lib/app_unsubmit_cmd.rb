module AresMUSH
  module Chargen
    class AppUnsubmitCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
      
      def want_command?(client, cmd)
        cmd.root_is?("app") && cmd.switch_is?("unsubmit")
      end

      def check_approval
        return t('chargen.you_are_already_approved') if client.char.is_approved
        return nil
      end
      
      def check_approval_job
        return t('chargen.you_have_not_submitted_app') if client.char.approval_job.nil?
        return nil
      end
      
      def handle
        Jobs.change_job_status(client,
          client.char.approval_job,
          Global.read_config("chargen", "jobs", "app_hold_status"),
          t('chargen.app_job_unsubmitted'))
          
        client.char.chargen_locked = false
        client.char.save
          
        client.emit_success t('chargen.app_unsubmitted')
      end
    end
  end
end