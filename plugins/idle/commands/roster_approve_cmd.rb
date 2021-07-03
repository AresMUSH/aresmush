module AresMUSH
  module Idle
    class RosterApproveCmd
      include CommandHandler
      
      attr_accessor :name, :comment, :is_approved
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = titlecase_arg(args.arg1)
        self.comment = args.arg2
        self.is_approved = cmd.switch_is?("approve")
      end
      
      def required_args
        [ self.name, self.comment ]
      end
      
      def check_permission
        return nil if Idle.can_manage_roster?(enactor)
        return t('dispatcher.not_allowed')
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          if (self.is_approved)
            error = Idle.approve_roster(enactor, model, self.comment)
            message = t('idle.roster_app_approved', :name => model.name)
          else
            error = Idle.reject_roster(enactor, model, self.comment)
            message = t('idle.roster_app_rejected', :name => model.name)
          end
          
          if (error)
            client.emit_failure error
          else
            client.emit_success message
          end
        end
      end
    end
  end
end