module AresMUSH
  module Chargen
    class AppSubmitCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutArgs
      
      def want_command?(client, cmd)
        cmd.root_is?("app") && (cmd.switch_is?("submit") || cmd.switch_is?("confirm"))
      end
      
      def handle
        if (client.char.approval_job.nil?)
          if (cmd.switch_is?("confirm"))
            create_job
          else
            client.emit_ooc t('chargen.app_confirm')
          end
        else
          update_job
        end
      
        client.char.chargen_locked = true
        client.char.save
      end
      
      def check_approval
        return t('chargen.you_are_already_approved') if client.char.is_approved
        return nil
      end
      
      def create_job
        job = Jobs.create_job(Global.config["chargen"]["jobs"]["app_category"], 
          t('chargen.application_title', :name => client.name), 
          t('chargen.app_job_submitted'), 
          client.char)
        
        if (!job[:error].nil?)
          Global.logger.error "Problem submitting application: #{job[:error]}"
          client.emit_failure t('chargen.app_job_problem')
          return
        end
        
        client.char.approval_job = job[:job]
        client.char.save        
        client.emit_success t('chargen.app_submitted')
      end
      
      def update_job
        Jobs.change_job_status(client,
          client.char.approval_job,
          Global.config["chargen"]["jobs"]["app_resubmit_status"],
          t('chargen.app_job_resubmitted'))
          
        client.emit_success t('chargen.app_resubmitted')
      end
    end
  end
end