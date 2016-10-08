module AresMUSH
  module Chargen
    class AppSubmitCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
      
      attr_accessor :chargen_info
      
      def check_approval
        return t('chargen.you_are_already_approved') if enactor.is_approved?
        return nil
      end
      
      def handle
        self.chargen_info = enactor.chargen_info
        
        job = Chargen.approval_job(enactor)
        if (!job)
          if (cmd.switch_is?("confirm"))
            job = create_job
            self.chargen_info.approval_job = job
            self.chargen_info.chargen_locked = true
            client.emit_success t('chargen.app_submitted')
          else
            client.emit_ooc t('chargen.app_confirm')
          end
        else
          update_job(job)
          self.chargen_info.chargen_locked = true
          client.emit_success t('chargen.app_resubmitted')
        end
        self.chargen_info.save
      end
      
      
      def create_job
        job = Jobs::Api.create_job(Global.read_config("chargen", "jobs", "app_category"), 
          t('chargen.application_title', :name => enactor_name), 
          t('chargen.app_job_submitted'), 
          enactor)
        
        if (job[:error])
          raise "Problem submitting application: #{job[:error]}"
        end
        job
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