module AresMUSH
  module Utils
    class NoteAddCmd
      include CommandHandler
      
      attr_accessor :name, :text

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = titlecase_arg(args.arg1)
        self.text = trim_arg(args.arg2)
      end
      
      def required_args
        [ self.name, self.text ]
      end
      
      def handle
        notes = enactor.notes
        
        notes[self.name] = self.text
        enactor.update(notes: notes)

        client.emit_success t('notes.note_added')
      end
    end
  end
end
