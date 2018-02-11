module AresMUSH
  module Utils
    class NotesCmd
      include CommandHandler
      
      def handle
        list = enactor.notes.map { |k, v| "%ld%R%xh#{k}%xn%R#{v}%R"}
        template = BorderedListTemplate.new list, t('notes.notes_title')
        client.emit template.render
      end
    end
  end
end
