module AresMUSH
  module Chargen
    class AppApproveCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name
      
      def crack!
        self.name = trim_input(cmd.args)
      end
      
      def required_args
        {
          args: [ self.name ],
          help: 'app'
        }
      end
      
      def check_permission
        return t('dispatcher.not_allowed') if !Chargen.can_approve?(enactor)
        return nil
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          if (model.is_approved?)
            client.emit_failure t('chargen.already_approved', :name => model.name) 
            return
          end

          info = model.get_or_create_chargen_info
          job = info.approval_job

          if (!job)
            client.emit_failure t('chargen.no_app_submitted', :name => model.name)
            return
          end
          
          Jobs::Api.close_job(enactor, job, Global.read_config("chargen", "messages", "approval"))
          
          model.update(is_approved: true)
          info.delete
          
          client.emit_success t('chargen.app_approved', :name => model.name)
          
          Bbs::Api.system_post(
            Global.read_config("chargen", "arrivals_board"),
            t('chargen.approval_bbs_subject'), 
            t('chargen.approval_bbs_body', :name => model.name))
        end
      end
    end
  end
end