module AresMUSH
  module Chargen
    class AppSubmitCmd
      include CommandHandler
      
      attr_accessor :chargen_info
      
      def check_approval
        return t('chargen.you_are_already_approved') if enactor.is_approved?
        return nil
      end
      
      def check_can_advance
        return t('chargen.not_started') if !Chargen.current_stage(enactor)
        return nil
      end
      
      def handle
        info = enactor.get_or_create_chargen_info
        job = info.approval_job
        
        if (!job)
          if (cmd.switch_is?("confirm"))
            job = create_job
            info.update(locked: true)
            info.update(approval_job: job)
            client.emit_success t('chargen.app_submitted')
          else
            client.emit_ooc t('chargen.app_confirm')
          end
        else
          info.update(locked: true)
          update_job(job)
          client.emit_success t('chargen.app_resubmitted')
        end
      end
      
      
      def create_job
        job = Jobs::Api.create_job(Global.read_config("chargen", "jobs", "app_category"), 
          t('chargen.application_title', :name => enactor_name), 
          t('chargen.app_job_submitted'), 
          enactor)
        
        if (job[:error])
          raise "Problem submitting application: #{job[:error]}"
        end
        enactor.client.emit_ooc t('chargen.approval_reminder')
        job[:job]
      end
      
      def update_job(job)
        Jobs::Api.change_job_status(enactor,
          job,
          Global.read_config("chargen", "jobs", "app_resubmit_status"),
          t('chargen.app_job_resubmitted'))
      end
    end
  end
end
