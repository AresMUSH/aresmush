module AresMUSH

  module Roster
    class RosterAddCmd
      include CommandHandler
      
      attr_accessor :name, :contact
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_optional_arg2)
        self.name = titleize_input(cmd.args.arg1)
        self.contact = titleize_input(cmd.args.arg2)
      end
       
      def required_args
        {
          args: [ self.name ],
          help: 'roster'
        }
      end
      
      def check_can_add
        return nil if Roster.can_manage_roster?(enactor)
        return t('dispatcher.not_allowed')
      end

      def handle
        Roster.create_or_update_roster(client, enactor, self.name, self.contact)
      end
    end
  end
end
