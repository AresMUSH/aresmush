module AresMUSH
  module Chargen
    class AppRejectCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name, :message
      
      def initialize(client, cmd, enactor)
        self.required_args = ['name', 'message']
        self.help_topic = 'app'
        super
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.name = trim_input(cmd.args.arg1)
        self.message = cmd.args.arg2
      end
      
      def check_permission
        return t('dispatcher.not_allowed') if !Chargen.can_approve?(enactor)
        return nil
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          if (model.is_approved)
            client.emit_failure t('chargen.already_approved', :name => model.name) 
            return
          end

          if (!model.approval_job)
            client.emit_failure t('chargen.no_app_submitted', :name => model.name)
            return
          end
          
          model.chargen_locked = false
          model.save
          
          Jobs::Api.change_job_status(enactor,
            model.approval_job,
            Global.read_config("chargen", "jobs", "app_hold_status"),
            "#{Global.read_config("chargen", "messages", "rejection")}%R%R#{self.message}")
                      
          client.emit_success t('chargen.app_rejected', :name => model.name)
        end
      end
    end
  end
end