module AresMUSH
  module Utils
    class NoteAddCmd
      include CommandHandler
      
      attr_accessor :name, :text, :target, :section

      def parse_args
        # Admin version
        if (cmd.args =~ /\//)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
          self.target = titlecase_arg(args.arg1)
          self.name = titlecase_arg(args.arg2)
          self.text = trim_arg(args.arg3)
          self.section = 'admin'
        else
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.target = enactor_name
          self.name = titlecase_arg(args.arg1)
          self.text = trim_arg(args.arg2)
          self.section = 'player'
        end
      end
      
      def required_args
        [ self.name, self.text ]
      end
      
      def check_is_allowed
        return nil if self.target == enactor_name
        return nil if Utils.can_access_notes?(enactor)
        return t('dispatcher.not_allowed')
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|
          notes = model.notes_section(self.section)
        
          if (self.target != enactor_name)
            note_record = t('notes.note_added_by', :name => enactor_name, :date => Time.now)
            self.text = "#{note_record}\n#{self.text}"
          end
          
          notes[self.name] = self.text
          model.update_notes_section(self.section, notes)

          client.emit_success t('notes.note_added')
        end
      end
    end
  end
end
