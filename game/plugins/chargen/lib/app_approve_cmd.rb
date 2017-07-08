module AresMUSH
  module Chargen
    class AppApproveCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = trim_arg(cmd.args)
      end
      
      def required_args
        {
          args: [ self.name ],
          help: 'chargen admin'
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

          job = model.approval_job

          if (!job)
            client.emit_failure t('chargen.no_app_submitted', :name => model.name)
            return
          end
          
          Jobs.close_job(enactor, job, Global.read_config("chargen", "messages", "approval"))
          
          model.update(is_approved: true)
          model.update(approval_job: nil)
          
          client.emit_success t('chargen.app_approved', :name => model.name)
          
          welcome_message = Global.read_config("chargen", "messages", "welcome")
          bbs_body = welcome_message % { :name => model.name, :position => model.group("Position") }
          
          Bbs.system_post(
            Global.read_config("chargen", "arrivals_board"),
            t('chargen.approval_bbs_subject', :name => model.name), 
            bbs_body)
            
          Jobs.create_job(Global.read_config("chargen", "jobs", "app_category"), 
             t('chargen.approval_bbs_subject', :name => model.name), 
             Global.read_config("chargen", "messages", "post_approval"), 
             Game.master.system_character)
        end
      end
    end
  end
end