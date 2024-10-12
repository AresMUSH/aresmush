module AresMUSH
  module Events
    class CharIdledOutEventHandler
      def on_event(event)
        # No need to reset if they're getting destroyed.
        return if event.is_destroyed?

        Global.logger.debug "Resetting event signups for #{event.char_id}"

        char = Character[event.char_id]
        char.delete_signups
      end
    end
  end
end