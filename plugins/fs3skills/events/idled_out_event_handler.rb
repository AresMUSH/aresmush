module AresMUSH
  module FS3Skills
    class CharIdledOutEventHandler
      def on_event(event)
        # No need to reset if they're getting destroyed.
        return if event.is_destroyed?
        
        char = Character[event.char_id]
        char.reset_xp
      end
    end
  end
end