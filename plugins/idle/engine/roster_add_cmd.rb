module AresMUSH

  module Idle
    class RosterAddCmd
      include CommandHandler
      
      attr_accessor :name, :contact
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.name = titlecase_arg(args.arg1)
        self.contact = titlecase_arg(args.arg2)
      end
       
      def required_args
        [ self.name ]
      end
      
      def check_roster_enabled
        return t('idle.roster_disabled') if !Idle.roster_enabled?
        return nil
      end
      
      def check_can_add
        return nil if Idle.can_manage_roster?(enactor)
        return t('dispatcher.not_allowed')
      end

      def handle
        Idle.create_or_update_roster(client, enactor, self.name, self.contact)
      end
    end
  end
end
