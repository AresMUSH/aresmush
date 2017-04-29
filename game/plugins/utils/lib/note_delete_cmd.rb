module AresMUSH
  module Utils
    class NoteDeleteCmd
      include CommandHandler
      
      attr_accessor :name

      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def required_args
        {
          args: [ self.name ],
          help: 'notes'
        }
      end
      
      def handle
        notes = enactor.notes
        
        if (!notes.has_key?(self.name))
          client.emit_failure t('notes.note_does_not_exist')
          return
        end
        
        notes.delete self.name
        enactor.update(notes: notes)

        client.emit_success t('notes.note_deleted')
      end
    end
  end
end
