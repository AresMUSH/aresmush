module AresMUSH
  module Utils
    class NoteDeleteCmd
      include CommandHandler
      
      attr_accessor :name, :target, :section

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        if (args.arg2)
          self.target = titlecase_arg(args.arg1)
          self.name = titlecase_arg(args.arg2)
          self.section = 'admin'
        else
          self.target = enactor_name
          self.name = titlecase_arg(args.arg1)
          self.section = 'player'
        end
      end
      
      def required_args
        [ self.name ]
      end
      
      def check_is_allowed
        return nil if self.target == enactor_name
        return nil if Utils.can_access_notes?(enactor)
        return t('dispatcher.not_allowed')
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
          notes = model.notes_section(self.section)
        
          if (!notes.has_key?(self.name))
            client.emit_failure t('notes.note_does_not_exist')
            return
          end
        
          notes.delete self.name
          model.update_notes_section(self.section, notes)

          client.emit_success t('notes.note_deleted')
        end
      end
    end
  end
end
