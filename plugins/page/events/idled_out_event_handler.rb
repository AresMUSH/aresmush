module AresMUSH
  module Page
    class CharIdledOutEventHandler
      def on_event(event)
        char = Character[event.char_id]
        char.delete_pages
      end
    end
  end
end