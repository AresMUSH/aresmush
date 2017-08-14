module AresMUSH

  module Idle
    class RosterNoteCmd
      include CommandHandler
      
      attr_accessor :name, :notes
      
      def help
        "`roster/notes <name>=<notes>` - Adds roster notes."
      end
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.name = titlecase_arg(args.arg1)
        self.notes = args.arg2
      end
       
      def required_args
        [ self.name, self.notes ]
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
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          if (!model.on_roster?)
            client.emit_failure t('idle.not_on_roster', :name => model.name)
            return
          end

          model.update(roster_notes: self.notes)
          client.emit_success t('idle.roster_updated')
        end
      end
    end
  end
end
