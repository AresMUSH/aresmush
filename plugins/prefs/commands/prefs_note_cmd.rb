module AresMUSH
  module Prefs
    class PrefsNoteCmd
      include CommandHandler
                
      attr_accessor :notes
            
      def parse_args
        self.notes = cmd.args
      end
      
      def handle
        enactor.update(prefs_notes: self.notes)
        if (self.notes)
          client.emit_success t('prefs.notes_set')
        else
          client.emit_success t('prefs.notes_cleared')
        end
      end
    end
  end
end
