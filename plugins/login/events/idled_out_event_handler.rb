module AresMUSH
  module Login
    class CharIdledOutEventHandler
      def on_event(event)
        # No need to reset if they're getting destroyed.
        return if event.is_destroyed?

        Global.logger.debug "Resetting login info for #{event.char_id}"

        char = Character[event.char_id]
        char.wipe_login_data
      end
    end
  end
end