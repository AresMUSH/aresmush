module AresMUSH
  module Utils
    class NotesCmd
      include CommandHandler
      
      def handle
        list = enactor.notes.map { |k, v| "%ld%R%xh#{k}%xn%R#{v}%R"}
        client.emit BorderedDisplay.list list, t('notes.notes_title')
      end
    end
  end
end
