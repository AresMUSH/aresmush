module AresMUSH
  module Chargen
    class AppSubmitCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
      
      def handle
        if (!enactor.approval_job)
          if (cmd.switch_is?("confirm"))
            create_job
            lock_char
          else
            client.emit_ooc t('chargen.app_confirm')
          end
        else
          update_job
          lock_char
        end
      end
      
      def lock_char
        enactor.chargen_locked = true
        enactor.save
      end
      
      def check_approval
        return t('chargen.you_are_already_approved') if enactor.is_approved
        return nil
      end
      
      def create_job
        job = Jobs::Api.create_job(Global.read_config("chargen", "jobs", "app_category"), 
          t('chargen.application_title', :name => enactor_name), 
          t('chargen.app_job_submitted'), 
          enactor)
        
        if (!job[:error].nil?)
          Global.logger.error "Problem submitting application: #{job[:error]}"
          client.emit_failure t('chargen.app_job_problem')
          return
        end
        
        enactor.approval_job = job[:job]
        enactor.save        
        client.emit_success t('chargen.app_submitted')
      end
      
      def update_job
        Jobs::Api.change_job_status(enactor,
          enactor.approval_job,
          Global.read_config("chargen", "jobs", "app_resubmit_status"),
          t('chargen.app_job_resubmitted'))
          
        client.emit_success t('chargen.app_resubmitted')
      end
    end
  end
end