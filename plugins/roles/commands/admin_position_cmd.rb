module AresMUSH
  module Roles
    class AdminPositionCmd
      include CommandHandler
      
      attr_accessor :note, :target

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        if (cmd.args =~ /=/)
          self.target = titlecase_arg(args.arg1)
          self.note = args.arg2
        else
          self.note = args.arg1
          self.target = enactor_name
        end
      end
      
      def check_can_set
        return nil if self.target == enactor_name
        return nil if enactor.is_admin?
        return t('dispatcher.not_allowed')
      end
      
      def handle      
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
          model.update(role_admin_note: self.note)
          client.emit_success t('roles.admin_position_set')
        end
      end
    end
  end
end