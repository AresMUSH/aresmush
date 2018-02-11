module AresMUSH
  module Chargen
    class AppApproveCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = trim_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
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
          
          Jobs.close_job(enactor, job, Global.read_config("chargen", "approval_message"))
          
          model.update(is_approved: true)
          model.update(approval_job: nil)
          role = Role.find_one(name: "approved")
          if (role)
            model.roles.add role
          end
          
          client.emit_success t('chargen.app_approved', :name => model.name)
          
          welcome_message = Global.read_config("chargen", "welcome_message")
          post_body = welcome_message % { :name => model.name, :position => model.group("Position") }
          
          Forum.system_post(
            Global.read_config("chargen", "arrivals_category"),
            t('chargen.approval_post_subject', :name => model.name), 
            post_body)
            
          Jobs.create_job(Global.read_config("chargen", "app_category"), 
             t('chargen.approval_post_subject', :name => model.name), 
             Global.read_config("chargen", "post_approval_message"), 
             Game.master.system_character)
        end
      end
    end
  end
end