module AresMUSH
  module Chargen
    class AppRejectCmd
      include CommandHandler
      
      attr_accessor :name, :message
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = trim_arg(args.arg1)
        self.message = args.arg2
      end
      
      def required_args
        {
          args: [ self.name, self.message ],
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
          
          model.update(chargen_locked: false)
          
          Jobs.change_job_status(enactor,
            job,
            Global.read_config("chargen", "jobs", "app_hold_status"),
            "#{Global.read_config("chargen", "messages", "rejection")}%R%R#{self.message}")
                      
          client.emit_success t('chargen.app_rejected', :name => model.name)
        end
      end
    end
  end
end