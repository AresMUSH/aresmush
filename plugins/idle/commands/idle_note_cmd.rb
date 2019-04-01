module AresMUSH

  module Idle
    class IdleNotesCmd
      include CommandHandler
      
      attr_accessor :name, :value
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.name = titlecase_arg(args.arg1)
        self.value = args.arg2
      end
       
      def required_args
        [ self.name ]
      end
      
      def check_can_manage
        return nil if Idle.can_idle_sweep?(enactor)
        return t('dispatcher.not_allowed')
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|          
          model.update(idle_notes: self.value)
          client.emit_success t('idle.idle_notes_updated')
        end
      end
    end
  end
end
