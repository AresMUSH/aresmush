module AresMUSH
  module Page
    class CharIdledOutEventHandler
      def on_event(event)
        # No need to reset if they're getting destroyed.
        return if event.is_destroyed?

        Global.logger.debug "Deleting PMs for #{event.char_id}"

        char = Character[event.char_id]
        char.delete_pages
      end
    end
  end
end