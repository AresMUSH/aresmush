module AresMUSH
  module Chargen
    class AppOverrideCmd
      include CommandHandler
      
      attr_accessor :name, :notes
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        
        self.name = trim_arg(args.arg1)
        self.notes = trim_arg(args.arg2)
      end
      
      def check_permission
        return t('dispatcher.not_allowed') if !Chargen.can_approve?(enactor)
        return nil
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
        
          if model.is_approved?
            client.emit_failure t('chargen.already_approved', :name => model.name) 
            return
          end
        
         Chargen.submit_app(model, t('chargen.approval_submitted_by_admin', :name => enactor_name))
          
          error = Chargen.approve_char(enactor, model, self.notes)
          if (error)
            client.emit_failure error
          else
            client.emit_success t('chargen.app_approved', :name => model.name)
          end
          
        end
      end
    end
  end
end